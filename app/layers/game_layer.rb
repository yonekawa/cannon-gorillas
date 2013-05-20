class GameLayer < Joybox::Core::Layer
  scene

  def on_enter
    init_world

    on_touches_ended do |touches, event|
      fire
    end

    schedule_update do |delta|
      @world.step(delta: delta)
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

  def fire
    cannon_ball = create_cannon_ball
    self << cannon_ball
    cannon_ball.body.apply_force(force: [6000, 100])
  end

  def create_cannon_ball
    cannon_ball_body = @world.new_body(
      position: [Screen.half_width, Screen.half_height],
      type: KDynamicBodyType
    ) do
      polygon_fixture(
        box: [56, 68],
        friction: 0.3,
        density: 1.0
      )
    end

    PhysicsSprite.new(file_name: 'gorilla.png', body: cannon_ball_body)
  end
end
