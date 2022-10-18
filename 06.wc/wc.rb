#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

max_length = 7
output = []

options = {}

def get_output_array(raw_lines, options)
  text = raw_lines.join

  line_count = raw_lines.size
  word_count = text.split.length
  byte_count = text.bytesize

  output_array = []
  output_array.push(line_count.to_s) if options[:lines]
  output_array.push(word_count.to_s) if options[:words]
  output_array.push(byte_count.to_s) if options[:bytes]
  output_array
end

parser = OptionParser.new
parser.on('-l', 'Lines count') do
  options[:lines] = true
end
parser.on('-w', 'Words count') do
  options[:words] = true
end
parser.on('-c', 'Bytes count') do
  options[:bytes] = true
end
parser.parse!

if options.empty?
  options[:lines] = true
  options[:words] = true
  options[:bytes] = true
end

if ARGV[0]
  if File.file?(ARGV[0])
    output = get_output_array(File.readlines(ARGV[0]), options)
    max_length = output.map(&:length).max
    output.push(ARGV[0])
  elsif File.directory?(ARGV[0])
    puts "wc: #{ARGV[0]}: Is a directory"
  else
    puts "wc: #{ARGV[0]}: No such file or directory"
  end
else
  output = get_output_array(readlines, options)
end

puts output.map { |number| format("%#{max_length}s", number) }.join(' ')
