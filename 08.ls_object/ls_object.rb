#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ShortPrinter'
require_relative 'DetailPrinter'

def args_parse
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

def get_files(options)
  Dir.glob('*', options[:hidden_files], base: options[:directory]).sort
end

options = args_parse
files = get_files(options)
files.reverse! if options[:reverse]

printer = options[:long_format] ? DetailPrinter.new(options[:directory]) : ShortPrinter.new
printer.print_output(files)