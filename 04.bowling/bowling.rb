#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGV[0].to_s.split(',')

frames = 1
total_score = 0
frame_score = 0
frame_shot_num = 0

def get_score(score)
  score == 'X' ? 10 : score.to_i
end

input.each_with_index do |score, index|
  frame_score += get_score(score)
  frame_shot_num += 1

  if frames < 10
    if score == 'X'
      total_score += (frame_score + get_score(input[index + 1]) + get_score(input[index + 2]))
      frame_score = 0
      frame_shot_num = 0
      frames += 1
    elsif frame_score == 10
      total_score += (frame_score + get_score(input[index + 1]))
      frame_score = 0
      frame_shot_num = 0
      frames += 1
    elsif frame_shot_num == 2
      total_score += frame_score
      frame_score = 0
      frame_shot_num = 0
      frames += 1
    end
  else
    total_score += frame_score
    frame_score = 0
  end
end

puts total_score
