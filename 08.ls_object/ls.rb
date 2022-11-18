# frozen_string_literal: true

require_relative 'printer'
require_relative 'file_detail'

class LS
  def initialize(options)
    @long_format = options[:long_format]
    @hidden_files = options[:hidden_files]
    @reverse = options[:reverse]
    @directory = options[:directory]
  end

  def output
    printer = Printer.new(@long_format, files_detail)
    printer.print
  end

  private

  def files_detail
    files = Dir.glob('*', @hidden_files, base: @directory).sort
    files = files.reverse if @reverse
    files.map { |name| FileDetail.new(File.join(@directory, name)) }
  end
end
