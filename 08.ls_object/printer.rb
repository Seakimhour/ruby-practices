# frozen_string_literal: true

class Printer
  require_relative 'file_detail'

  NUMBER_OF_COLUMN = 3

  def initialize(directory, long_format, files)
    @long_format = long_format
    @files_detail = files_detail_array(directory, files)
  end

  def files_detail_array(directory, files)
    files.map { |name| FileDetail.new(directory, name) }
  end

  def print
    @long_format ? detail_format : short_format
  end

  def short_format
    number_of_row = (@files_detail.count / NUMBER_OF_COLUMN.to_f).ceil

    number_of_row.times do |row|
      NUMBER_OF_COLUMN.times do |column|
        index = row + column * number_of_row
        printf(@files_detail[index].name_with_padding) if @files_detail[index]
      end
      puts
    end
  end

  def detail_format
    total_block = @files_detail.map { |file| file.stat[:blocks] }.sum
    columns_length = find_columns_length(@files_detail)

    # ls use --block-size=1024 while File::Stat Blocks use 512B make it return double the size compared to ls
    puts "total #{total_block / 2}"

    @files_detail.each do |file|
      printf([
        '%<permission>s',
        "%<nlink>#{columns_length[:nlink]}i",
        "%<username>-#{columns_length[:username]}s",
        "%<groupname>-#{columns_length[:groupname]}s",
        "%<bytesize>#{columns_length[:bytesize]}s",
        '%<time>s',
        '%<filename>s'
      ].join(' '), file.stat)
      puts
    end
  end

  def find_columns_length(files_detail)
    {
      nlink: files_detail.map { |file| file.stat[:nlink].to_s.length }.max,
      username: files_detail.map { |file| file.stat[:username].length }.max,
      groupname: files_detail.map { |file| file.stat[:groupname].length }.max,
      bytesize: files_detail.map { |file| file.stat[:bytesize].to_s.length }.max
    }
  end
end
