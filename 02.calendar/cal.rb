#!/usr/bin/env ruby

require 'optparse'

input = ARGV.getopts('y:', 'm:')

now = Time.now

# use now if input not available
year = input['y'] ? input['y'].to_i : now.year
month = input['m'] ? input['m'].to_i : now.month

this_month = false
if now.year == year && now.month == month
  this_month = true
end

# Get first day of the month
start_day = Time.new(year, month).wday

# Get last date of the month
dates_in_month = (Time.new(year, (month % 12) + 1) - 1).day

# Print input calendar date
puts '      ' + month.to_s + '月　' + year.to_s

# Print day of week
puts ' 日 月 火 水 木 金 土'

current_day_of_week = 0

# Skip day
start_day.times do |d|
    print "   "
    current_day_of_week += 1
end

date = 1
while date <= dates_in_month
  if this_month && now.day == date
    if date < 10
      print "  \e[32m#{date.to_s}\e[0m"
    else
      print " \e[32m#{date.to_s}\e[0m"
    end
  else
    if date < 10
      print "  " + date.to_s
    else
      print " " + date.to_s
    end
  end
  
  date += 1
  current_day_of_week += 1

  # Reset week
  if current_day_of_week >= 7
    current_day_of_week = 0
    puts ' '
  end
end

puts ' '