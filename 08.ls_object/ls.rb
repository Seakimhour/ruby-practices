# frozen_string_literal: true

require_relative 'printer'

class LS
  def initialize(options)
    @directory = options[:directory]
    @long_format = options[:long_format]
    @files = get_files(options[:hidden_files], options[:reverse])
  end

  def output
    printer = Printer.new(@directory, @long_format, @files)
    printer.print
  end

  private

  def get_files(hidden_files_flags, reverse)
    files = Dir.glob('*', hidden_files_flags, base: @directory).sort
    files = files.reverse if reverse
    files
  end
end
