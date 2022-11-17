# frozen_string_literal: true

require_relative 'file_detail'

class Printer
  NUMBER_OF_COLUMN = 3

  def initialize(long_format, files_detail)
    @long_format = long_format
    @files_detail = files_detail
  end

  def print
    @long_format ? print_long_format : print_short_format
  end

  private

  def print_short_format
    columns_files = column_format
    columns_length = find_short_format_columns_length(columns_files)
    columns_files.each do |column|
      column.each_with_index do |filename, index|
        printf("%-#{columns_length[index]}s ", filename)
      end
      puts
    end
  end

  def column_format
    number_of_row = (@files_detail.count / NUMBER_OF_COLUMN.to_f).ceil

    column_files = []
    number_of_row.times do |row|
      column_files[row] = []
      NUMBER_OF_COLUMN.times do |column|
        index = row + column * number_of_row
        column_files[row][column] = @files_detail[index].filename if @files_detail[index]
      end
    end
    column_files
  end

  def find_short_format_columns_length(columns_files)
    transpose_columns_files = columns_files.reduce(&:zip).map(&:flatten).map
    transpose_columns_files.map { |files| files.map { |file| file ? file.length : 0 }.max }
  end

  def print_long_format
    columns_length = find_long_format_columns_length(@files_detail)

    puts "total #{@files_detail.sum(&:blocks) / 2}"
    @files_detail.each do |file|
      file_detail = file_detail_print_format(file)
      file_detail[:short_time_format] = file_detail[:time].strftime('%b %e %k:%M')
      printf([
        '%<permission>s',
        "%<nlink>#{columns_length[:nlink]}i",
        "%<username>-#{columns_length[:username]}s",
        "%<groupname>-#{columns_length[:groupname]}s",
        "%<bytesize>#{columns_length[:bytesize]}s",
        '%<short_time_format>s',
        '%<filename>s'
      ].join(' '), file_detail)
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

  def find_long_format_columns_length(files_detail)
    {
      nlink: files_detail.map { |file| file.nlink.to_s.length }.max,
      username: files_detail.map { |file| file.username.length }.max,
      groupname: files_detail.map { |file| file.groupname.length }.max,
      bytesize: files_detail.map { |file| file.bytesize.to_s.length }.max
    }
  end
end
