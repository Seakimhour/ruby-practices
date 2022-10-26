#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ls'

def options
  options = {
    directory: './',
    hidden_files: 0,
    long_format: false,
    reverse: false
  }

  parser = OptionParser.new
  parser.on('-a') { options[:hidden_files] = File::FNM_DOTMATCH }
  parser.on('-l') { options[:long_format] = true }
  parser.on('-r') { options[:reverse] = true }
  parser.parse!

  options[:directory] = ARGV[0] if ARGV[0] && Dir.exist?(ARGV[0])

  options
end

ls = LS.new(options)
ls.output
