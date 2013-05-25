class GameLayer < Joybox::Core::Layer
  GORILLA_WIDTH  = 47
  GORILLA_HEIGHT = 48.5
  BANANA_WIDTH = 49
  BANANA_HEIGHT = 44

  def on_enter
    init_world

    @destroyBodyQueue = []
    @is_gorilla_fired = false

    create_new_gorilla
    create_new_banana

    on_touches_ended do |touches, event|
      parent.increment_score

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

    distance_x = (to.x - @gorilla.position.x).abs * 10
    distance_y = (to.y - @gorilla.position.y).abs * 15
    distance_x *= -1 if to.x < @gorilla.position.x
    distance_y *= -1 if to.y < @gorilla.position.y
    torque = to.x < @gorilla.position.x ? -50 : 50

    @gorilla.body.apply_torque(torque: torque)
    @gorilla.body.apply_force(force: [distance_x, distance_y])

    @is_gorilla_fired = true
  end

  def create_new_gorilla
    return nil if @gorilla

    @gorilla_body = @world.new_body(
      position: [Screen.half_width - (GORILLA_WIDTH / 2), GORILLA_HEIGHT],
      type: KDynamicBodyType
    ) do
      polygon_fixture(
        box: [GORILLA_WIDTH, GORILLA_HEIGHT],
        friction: 0.7,
        density: 1.0
      )
    end

    @gorilla = PhysicsSprite.new(file_name: 'gorilla.png', body: @gorilla_body)
    # @world.when_collide(@gorilla_body) do |collision_body, is_touching|
    #  if @is_gorilla_fired
    #    # App crashes by assertion error if removing body here
    #    @destroyBodyQueue << @gorilla
    #
    #    explosion = CCParticleExplosion.node
    #    explosion.position = @gorilla.position
    #    explosion.duration = 1.0
    #    explosion.autoRemoveOnFinish = true
    #    self << explosion
    #
    #    self.removeChild(@gorilla)
    #    @gorilla = nil
    #  end
    #end

    self << @gorilla
  end

  def create_new_banana
    min_x = BANANA_WIDTH / 2
    min_y = BANANA_HEIGHT / 2

    random = Random.new(Time.new.to_i)

    @great_banana = Sprite.new(
      file_name: 'great_banana.png',
      position: [
        random.rand(0..Screen.width),
        random.rand(20..Screen.height)
      ]
    )
    @great_banana.run_action(banana_move)

    @bad_banana = Sprite.new(
      file_name: 'bad_banana.png',
      position: [
        random.rand(min_x..Screen.width - min_x),
        random.rand(min_y..Screen.height - min_y)
      ]
    )
    @bad_banana.run_action(banana_move)

    self << @great_banana
    self << @bad_banana
  end

  def banana_move
    action = Sequence.with(actions: [
      Rotate.to(duration:0.2, angle:5),
      Rotate.to(duration:0.2, angle:-5),
      Rotate.to(duration:0.2, angle:-5),
      Rotate.to(duration:0.2, angle:5),
    ])

    Repeat.forever(action: action)
  end
end
