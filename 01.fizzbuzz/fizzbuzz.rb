#!/usr/bin/env ruby

20.times do |x|
  x += 1
  str = x

  if (x % 3) == 0
    str = 'fizz'
  end
  if (x % 5) == 0
    if str == 'fizz'
      str = 'buzzfizz'
    else
      str = 'buzz'
    end
  end
  
  puts str
end
