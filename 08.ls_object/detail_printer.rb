# frozen_string_literal: true

class DetailPrinter
  require 'etc'

  FILE_PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(directory)
    @directory = directory
  end

  def readable_permission(file_path)
    mode = format('%o', File.stat(file_path).mode)
    path_type = File.directory?(file_path) ? 'd' : '-'
    path_type + mode[-3..].chars.map { |digit| FILE_PERMISSION[digit] }.join
  end

  def print_output(files)
    files_detail = files.map { |file| file_detail_format(file) }
    total_block = files_detail.map { |file| file[:blocks] }.sum
    columns_length = find_columns_length(files_detail)

    # ls use --block-size=1024 while File::Stat Blocks use 512B make it return double the size compared to ls
    puts "total #{total_block / 2}"

    files_detail.each do |stat|
      printf([
        '%<permission>s',
        "%<nlink>#{columns_length[:nlink]}i",
        "%<username>-#{columns_length[:username]}s",
        "%<groupname>-#{columns_length[:groupname]}s",
        "%<bytesize>#{columns_length[:bytesize]}s",
        '%<time>s',
        '%<filename>s'
      ].join(' '), stat)
      puts
    end
  end

  def find_columns_length(files_detail)
    {
      nlink: files_detail.map { |stat| stat[:nlink].to_s.length }.max,
      username: files_detail.map { |stat| stat[:username].length }.max,
      groupname: files_detail.map { |stat| stat[:groupname].length }.max,
      bytesize: files_detail.map { |stat| stat[:bytesize].to_s.length }.max
    }
  end

  def file_detail_format(file)
    file_path = @directory + file

    file_stat = File.stat(file_path)

    {
      blocks: file_stat.blocks,
      permission: readable_permission(file_path),
      nlink: file_stat.nlink,
      username: Etc.getpwuid(file_stat.uid).name,
      groupname: Etc.getgrgid(file_stat.gid).name,
      bytesize: file_stat.size,
      time: file_stat.ctime.ctime,
      filename: file
    }
  end
end
