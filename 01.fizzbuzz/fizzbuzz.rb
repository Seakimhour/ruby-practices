#!/usr/bin/env ruby

(1..20).each do |x|
  str = ''
  str += 'Fizz' if x % 3 == 0
  str += 'Buzz' if x % 5 == 0
  str = x if str == ''
  puts str
end
