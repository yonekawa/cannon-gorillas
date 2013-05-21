class GameLayer < Joybox::Core::Layer
  scene

  GORILLA_WIDTH  = 28
  GORILLA_HEIGHT = 34

  def on_enter
    init_world

    @destroyBodyQueue = []
    @is_gorilla_fired = false
    create_new_gorilla

    on_touches_ended do |touches, event|
      touch = touches.anyObject
      location = touch.locationInView(touch.view)
      location = Director.sharedDirector.convertToGL(location)

      fire(location)
    end

    schedule_update do |delta|
      @world.step(delta: delta)

      @destroyBodyQueue.each do |sprite|
        @world.removeBody(sprite.body)
        @is_gorilla_fired = false

        self.scheduleOnce('create_new_gorilla', delay: 1.0)
      end
      @destroyBodyQueue = []
    end
  end

  def on_exit
  end

  private

  def init_world
    @world = World.new(gravity: [0, -10])
    body = @world.new_body(position: [0, 0]) do
      edge_fixture start_point: [0, 0],
                   end_point:   [Screen.width, 0]
      edge_fixture start_point: [0, Screen.height],
                   end_point:   [Screen.width, Screen.height]
      edge_fixture start_point: [0, Screen.height],
                   end_point:   [0, 0]
      edge_fixture start_point: [Screen.width, Screen.height],
                   end_point:   [Screen.width, 0]
    end
  end

  def fire(to)
    return unless @gorilla

    distanceX = (to.x - @gorilla.position.x).abs
    distanceX *= -1 if to.x < @gorilla.position.x
    @gorilla.body.apply_force(force: [300 * (distanceX / 50), 300])
    @gorilla.body.apply_torque(torque: 20)

    @is_gorilla_fired = true
  end

  def explosion(position)

  end

  def create_new_gorilla
    return nil if @gorilla

    @gorilla_body = @world.new_body(
      position: [Screen.half_width - (GORILLA_WIDTH / 2), GORILLA_HEIGHT],
      type: KDynamicBodyType
    ) do
      polygon_fixture(
        box: [GORILLA_WIDTH, GORILLA_HEIGHT],
        friction: 0.3,
        density: 1.0
      )
    end

    @gorilla = PhysicsSprite.new(file_name: 'gorilla.png', body: @gorilla_body)
    @world.when_collide(@gorilla_body) do |collision_body, is_touching|
      if @is_gorilla_fired
        # App crashes by assertion error if removing body here
        @destroyBodyQueue << @gorilla

        explosion = CCParticleExplosion.node
        explosion.position = @gorilla.position
        explosion.duration = 1.0
        explosion.autoRemoveOnFinish = true
        self << explosion

        self.removeChild(@gorilla)
        @gorilla = nil
      end
    end

    self << @gorilla
  end
end
