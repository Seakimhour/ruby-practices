#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGV[0].to_s.split(',')

frames = 1
total_score = 0
sum = 0
n = 0

def get_score(score)
  score == 'X' ? 10 : score.to_i
end

input.each_with_index do |score, index|
  sum += get_score(score)
  n += 1

  if frames < 10
    if score == 'X'
      total_score += (sum + get_score(input[index + 1]) + get_score(input[index + 2]))
      sum = 0
      n = 0
      frames += 1
    elsif sum == 10
      total_score += (sum + get_score(input[index + 1]))
      sum = 0
      n = 0
      frames += 1
    elsif n == 2
      total_score += sum
      sum = 0
      n = 0
      frames += 1
    end
  else
    total_score += sum
    sum = 0
  end
end

puts total_score
