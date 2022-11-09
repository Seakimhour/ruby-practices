# frozen_string_literal: true

class FileDetail
  require 'etc'

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
    @stat = detail_stat
  end

  def name_with_padding
    name = @name.force_encoding(Encoding::UTF_8)
    name_without_half_width_katakana = name.gsub(/[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｯｧｨｩｪｫｬｭｮﾞﾟ]/u, '*')
    name_width = name_without_half_width_katakana.chars.map { |char| char.bytesize == 1 ? 1 : 2 }.sum
    name + ' ' * (COLUMN_WIDTH - name_width)
  end

  def permission
    mode = format('%o', File.stat(@file_path).mode)
    path_type = File.directory?(@file_path) ? 'd' : '-'
    path_type + mode[-3..].chars.map { |digit| FILE_PERMISSION[digit] }.join
  end

  def detail_stat
    file_stat = File.stat(@file_path)

    {
      blocks: file_stat.blocks,
      permission: permission,
      nlink: file_stat.nlink,
      username: Etc.getpwuid(file_stat.uid).name,
      groupname: Etc.getgrgid(file_stat.gid).name,
      bytesize: file_stat.size,
      time: file_stat.ctime.strftime('%b %e %k:%M'),
      filename: @name
    }
  end
end
