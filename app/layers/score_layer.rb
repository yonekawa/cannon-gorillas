# -*- coding: utf-8 -*-
class ScoreLayer < Joybox::Core::Layer
  BANANA_WIDTH = 24
  BANANA_HEIGHT = 22
  LABEL_WIDTH = 60
  LABEL_HEIGHT = 20

  attr_accessor :score

  def on_enter
    @score = 0

    @score_label = Label.new(text: "× #{@score.to_s}",
      font_size: 20,
      color: Color.new(255, 255, 255),
      position: [Screen.width - LABEL_WIDTH, Screen.height - LABEL_HEIGHT],
      dimensions: CGSizeMake(LABEL_WIDTH, LABEL_HEIGHT),
      alignment: Joybox::UI::Label::TextAlignmentLeft
    )
    self << @score_label

    banana_icon = Sprite.new(
      file_name: 'banana.png',
      position: [
        Screen.width - BANANA_WIDTH * 2 - LABEL_WIDTH + 2,
        Screen.height - BANANA_HEIGHT / 2 - 7
      ]
    )
    self << banana_icon
  end

  def increment_score
    @score += 1
    @score_label.text = "× #{@score.to_s}"
  end
end
