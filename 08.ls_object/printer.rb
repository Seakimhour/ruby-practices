# frozen_string_literal: true

require_relative 'file_detail'

class Printer
  NUMBER_OF_COLUMN = 3

  def initialize(directory, long_format, files)
    @long_format = long_format
    @files_detail = files_details(directory, files)
  end

  def print
    @long_format ? print_long_format : print_short_format
  end

  private

  def files_details(directory, files)
    files.map { |name| FileDetail.new(directory, name) }
  end

  def print_short_format
    number_of_row = (@files_detail.count / NUMBER_OF_COLUMN.to_f).ceil

    number_of_row.times do |row|
      NUMBER_OF_COLUMN.times do |column|
        index = row + column * number_of_row
        printf(@files_detail[index].name_with_padding) if @files_detail[index]
      end
      puts
    end
  end

  def print_long_format
    columns_length = find_columns_length(@files_detail)

    puts "total #{@files_detail.sum(&:blocks) / 2}"
    @files_detail.each do |file|
      printf([
        '%<permission>s',
        "%<nlink>#{columns_length[:nlink]}i",
        "%<username>-#{columns_length[:username]}s",
        "%<groupname>-#{columns_length[:groupname]}s",
        "%<bytesize>#{columns_length[:bytesize]}s",
        '%<time>s',
        '%<filename>s'
      ].join(' '), file_detail_print_format(file))
      puts
    end
  end

  def file_detail_print_format(file)
    {
      permission: file.permission,
      nlink: file.nlink,
      username: file.username,
      groupname: file.groupname,
      bytesize: file.bytesize,
      time: file.time,
      filename: file.filename
    }
  end

  def find_columns_length(files_detail)
    {
      nlink: files_detail.map { |file| file.nlink.to_s.length }.max,
      username: files_detail.map { |file| file.username.length }.max,
      groupname: files_detail.map { |file| file.groupname.length }.max,
      bytesize: files_detail.map { |file| file.bytesize.to_s.length }.max
    }
  end
end
