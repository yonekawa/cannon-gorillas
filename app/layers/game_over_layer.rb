# -*- coding: utf-8 -*-
class GameOverLayer < Joybox::Core::Layer
  SCORE_OFFSET = 30
  RETRY_OFFSET = 50

  attr_accessor :score

  def self.new(score = 0)
    layer =  GameOverLayer.alloc.init
    layer.score = score
    layer
  end

  def on_enter
    maskLayer = Joybox::Core::LayerColor.new(
      red: 0, green: 0, blue: 0, opacity: 128,
      width: Screen.width, height: Screen.height
    )
    self << maskLayer

    banana_icon = Sprite.new(
      file_name: 'good_banana.png',
      position: [Screen.half_width - 50, Screen.half_height + SCORE_OFFSET + 2]
    )
    self << banana_icon

    score_label = Label.new(
      text: "× #{@score.to_s}",
      font_size: 40,
      color: Color.new(255, 255, 255),
      position: [Screen.half_width + 40, Screen.half_height + SCORE_OFFSET],
      dimensions: [120, 40],
      alignment: Joybox::UI::Label::TextAlignmentLeft
    )
    self << score_label

    retry_label = Label.new(
      text: "Tap to Retry",
      font_size: 40,
      color: Color.new(255, 255, 255),
      position: [Screen.half_width, Screen.half_height - RETRY_OFFSET],
    )
    self << retry_label

    on_touches_ended do |touches, event|
      director.replace_scene(GameScene.new)
    end
  end
end
