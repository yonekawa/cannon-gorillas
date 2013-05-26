class GameLayer < Joybox::Core::Layer
  GORILLA_WIDTH  = 47
  GORILLA_HEIGHT = 48.5
  BANANA_WIDTH = 49
  BANANA_HEIGHT = 44

  def on_enter
    @scene = parent
    @is_game_over = false
    @is_caught_banana = false
    @is_fired_gorilla = true

    init_world

    create_new_gorilla
    create_new_banana

    on_touches_ended do |touches, event|
      unless @is_fired_gorilla
        @is_fired_gorilla = true

        touch = touches.anyObject
        location = touch.locationInView(touch.view)
        location = Director.sharedDirector.convertToGL(location)

        fire(location)
      end
    end

    schedule_update do |delta|
      game_tick(delta) unless @is_game_over
    end
  end

  private

  def game_tick(delta)
    @world.step(delta: delta)

    unless @gorilla.body.isAwake
      if @is_fired_gorilla
        @is_fired_gorilla = false
        create_new_gorilla
      end

      if @is_caught_banana
        @is_caught_banana = false
        create_new_banana
      end
    end

    if @good_banana && CGRectIntersectsRect(sprite_rect(@gorilla), sprite_rect(@good_banana))
      unless @is_caught_banana
        @is_caught_banana = true

        self.removeChild(@good_banana)
        @good_banana = nil

        @scene.score_layer.increment_score
      end
    end

    if CGRectIntersectsRect(sprite_rect(@gorilla), sprite_rect(@bad_banana))
      explosion = CCParticleExplosion.node
      explosion.position = CGPointMake(@gorilla.position.x, @gorilla.position.y)
      explosion.duration = 1.0
      explosion.autoRemoveOnFinish = true
      self << explosion

      @world.removeBody(@gorilla.body)
      self.removeChild(@gorilla)

      game_over
    end
  end

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
    distance_x = (to.x - @gorilla.position.x).abs * 10
    distance_y = (to.y - @gorilla.position.y).abs * 15
    distance_x *= -1 if to.x < @gorilla.position.x
    distance_y *= -1 if to.y < @gorilla.position.y
    torque = to.x < @gorilla.position.x ? -50 : 50

    @gorilla.body.apply_torque(torque: torque)
    @gorilla.body.apply_force(force: [distance_x, distance_y])
  end

  def create_new_gorilla
    position = [Screen.half_width - (GORILLA_WIDTH / 2), GORILLA_HEIGHT]
    if @gorilla
      position = [@gorilla.position.x, @gorilla.position.y]
      @world.removeBody(@gorilla.body)
      self.removeChild(@gorilla)
    end

    @gorilla_body = @world.new_body(
      position: position,
      type: KDynamicBodyType
    ) do
      polygon_fixture(
        box: [GORILLA_WIDTH, GORILLA_HEIGHT],
        friction: 0.7,
        density: 1.0
      )
    end

    @gorilla = PhysicsSprite.new(file_name: 'gorilla.png', body: @gorilla_body)
    self << @gorilla
  end

  def create_new_banana
    self.removeChild(@good_banana) if @good_banana
    self.removeChild(@bad_banana) if @bad_banana

    min_x = BANANA_WIDTH / 2
    min_y = BANANA_HEIGHT * 2 + GORILLA_HEIGHT

    random = Random.new(Time.new.to_i)

    @good_banana = Sprite.new(
      file_name: 'good_banana.png',
      position: [
        random.rand(min_x..Screen.width - min_x),
        random.rand(min_y..(Screen.height - BANANA_HEIGHT))
      ]
    )
    @good_banana.run_action(banana_move)

    @bad_banana = Sprite.new(
      file_name: 'bad_banana.png',
      position: [
        random.rand(min_x..Screen.width - min_x),
        random.rand(min_y..(Screen.height - BANANA_HEIGHT))
      ]
    )
    @bad_banana.run_action(banana_move)

    self << @good_banana
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

  def sprite_rect(sprite)
    bounds_factor = 10

    h = sprite.contentSize.height - bounds_factor
    w = sprite.contentSize.width - bounds_factor
    x = sprite.position.x - w / 2 + bounds_factor
    y = sprite.position.y - h / 2 + bounds_factor
    CGRectMake(x, y, w, h)
  end

  def game_over
    @is_game_over = true

    game_over_layer = GameOverLayer.new(@scene.score_layer.score)
    @scene << game_over_layer

    @scene.removeChild(@scene.score_layer)
  end
end
