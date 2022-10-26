# frozen_string_literal: true

class LS
  require_relative 'printer'

  def initialize(options)
    @directory = options[:directory]
    @long_format = options[:long_format]
    @files = get_files(options[:hidden_files], options[:reverse])
  end

  def get_files(hidden_files_flags, reverse)
    files = Dir.glob('*', hidden_files_flags, base: @directory).sort
    files.reverse! if reverse
    files
  end

  def output
    printer = Printer.new(@directory, @long_format, @files)
    printer.print
  end
end
