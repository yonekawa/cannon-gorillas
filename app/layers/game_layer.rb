class GameLayer < Joybox::Core::Layer
  scene

  def on_enter
    init_world

    on_touches_ended do |touches, event|
      touch = touches.anyObject
      location = touch.locationInView(touch.view)
      location = Director.sharedDirector.convertToGL(location)

      fire(location)
    end

    @destroyBodyQueue = []

    schedule_update do |delta|
      @world.step(delta: delta)

      @destroyBodyQueue.each do |sprite|
        @world.removeBody(sprite.body)
        self.removeChild(sprite)
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

  def fire(location)
    cannon_ball = create_cannon_ball
    return unless cannon_ball

    self << cannon_ball
    cannon_ball.body.apply_force(force: [300 * (location.x / 100), 300 * (location.y / 100)])
  end

  def create_cannon_ball
    return nil if @cannon_ball

    @cannon_ball_body = @world.new_body(
      position: [100, 100],
      type: KDynamicBodyType
    ) do
      polygon_fixture(
        box: [28, 34],
        friction: 0.3,
        density: 1.0
      )
    end

    @cannon_ball = PhysicsSprite.new(file_name: 'gorilla.png', body: @cannon_ball_body)
    @world.when_collide(@cannon_ball_body) do |collision_body, is_touching|
      # App crashes by assertion error if removing body here
      @destroyBodyQueue << @cannon_ball

      explosion = CCParticleExplosion.node
      explosion.position = @cannon_ball.position
      self << explosion

      self.removeChild(@cannon_ball)
      @cannon_ball = nil
    end

    @cannon_ball
  end
end
