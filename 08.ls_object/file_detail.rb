# frozen_string_literal: true

require 'etc'

class FileDetail
  attr_reader :stat

  COLUMN_WIDTH = 30

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

  def initialize(directory, name)
    @name = name
    @file_path = directory + name
    @file_stat = File.stat(@file_path)
  end

  def name_with_padding
    name = @name.force_encoding(Encoding::UTF_8)
    name_without_half_width_katakana = name.gsub(/[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｯｧｨｩｪｫｬｭｮﾞﾟ]/u, '*')
    name_width = name_without_half_width_katakana.chars.map { |char| char.bytesize == 1 ? 1 : 2 }.sum
    name + ' ' * (COLUMN_WIDTH - name_width)
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
    @file_stat.ctime.strftime('%b %e %k:%M')
  end

  def filename
    @name
  end

  def permission
    mode = format('%o', @file_stat.mode)
    path_type = File.directory?(@file_path) ? 'd' : '-'
    path_type + mode[-3..].chars.map { |digit| FILE_PERMISSION[digit] }.join
  end
end
