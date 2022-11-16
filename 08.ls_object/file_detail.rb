# frozen_string_literal: true

require 'etc'

class FileDetail
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

  def initialize(file_path)
    @file_path = file_path
    @file_stat = File.stat(@file_path)
  end

  def blocks
    @file_stat.blocks
  end

  def nlink
    @file_stat.nlink
  end

  def username
    Etc.getpwuid(@file_stat.uid).name
  end

  def groupname
    Etc.getgrgid(@file_stat.gid).name
  end

  def bytesize
    @file_stat.size
  end

  def time
    @file_stat.ctime
  end

  def filename
    @file_path.split('/').last
  end

  def permission
    mode = format('%o', @file_stat.mode)
    path_type = File.directory?(@file_path) ? 'd' : '-'
    path_type + mode[-3..].chars.map { |digit| FILE_PERMISSION[digit] }.join
  end
end
