#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frame_array

  def initialize(mark_array)
    @frame_array = get_frames(mark_array)
  end

  def get_frames(mark_array)
    frames = []
    frame_marks = []

    mark_array.each do |mark|
      frame_marks.push(mark)

      if frames.length < 9 && (frame_marks.length == 2 || mark == 'X')
        frames.push(Frame.new(frame_marks[0], frame_marks[1]))
        frame_marks = []
      end
    end
    frames.push(Frame.new(frame_marks[0], frame_marks[1], frame_marks[2]))
  end

  def score
    score = 0
    frame_array.each_with_index do |frame, index|
      if index == 9
        score += frame.raw_score
        next
      end

      score += if frame.strike?
                 strike_bonus(index)
               elsif frame.spare?
                 spare_bonus(index)
               else
                 frame.raw_score
               end
    end
    score
  end

  def strike_bonus(index)
    return 10 + frame_array[index + 1].first_shot.score + frame_array[index + 2].first_shot.score if frame_array[index + 1].strike? && index < 8

    10 + frame_array[index + 1].first_shot.score + frame_array[index + 1].second_shot.score
  end

  def spare_bonus(index)
    10 + frame_array[index + 1].first_shot.score
  end
end

mark_array = ARGV[0].to_s.split(',')

puts Game.new(mark_array).score
