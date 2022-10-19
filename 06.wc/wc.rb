#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

output = []

options = {}

def get_output_array(raw_lines, options)
  text = raw_lines.join

  line_count = raw_lines.size
  word_count = text.split.length
  byte_count = text.bytesize

  output_array = []
  output_array.push(line_count) if options[:lines]
  output_array.push(word_count) if options[:words]
  output_array.push(byte_count) if options[:bytes]
  output_array
end

def print_output(output_array, name_array)
  max_number_length = output_array.map { |number_array| number_array.map { |number| number.to_s.length }.max }.max

  output_array.each_with_index do |number_array, output_index|
    number_array.each do |number|
      print(format("%#{max_number_length}s ", number))
    end
    puts format("%#{max_number_length}s", name_array[output_index])
  end
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

if ARGV.any?
  ARGV.each do |arg|
    if File.file?(arg)
      output.push(get_output_array(File.readlines(arg), options))
    elsif File.directory?(arg)
      puts "wc: #{arg}: Is a directory"
    else
      puts "wc: #{arg}: No such file or directory"
    end
  end

  if ARGV.length > 1
    output.push(output.transpose.map(&:sum))
    ARGV.push('total')
  end
else
  output.push(get_output_array(readlines, options))
end

print_output(output, ARGV)
