class GameScene < Joybox::Core::Scene

  attr_accessor :game_layer, :score_layer

  def on_enter
    @background_layer = BackgroundLayer.new
    self << @background_layer

    @game_layer = GameLayer.new
    self << @game_layer

    @score_layer = ScoreLayer.new
    self << @score_layer
  end
end
