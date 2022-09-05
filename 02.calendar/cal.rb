#!/usr/bin/env ruby

require 'optparse'
require 'date'

input = ARGV.getopts('y:', 'm:')

now = Date.today
year = input['y'] ? input['y'].to_i : now.year
month = input['m'] ? input['m'].to_i : now.month
this_month = now.year == year && now.month == month

current_day_of_week = Date.new(year, month).wday
puts '     ' + month.to_s + '月　' + year.to_s
puts '日 月 火 水 木 金 土'
print "   " * current_day_of_week

dates_in_month = Date.new(year, month, -1).day

(1..dates_in_month).each do |date|
  if this_month && now.day == date
    print "\e[32m#{date.to_s.rjust(2) + ' '}\e[0m"
  else 
    print date.to_s.rjust(2) + ' '
  end

  if current_day_of_week < 6
    current_day_of_week += 1
  else
    current_day_of_week = 0
    puts
  end
end

puts