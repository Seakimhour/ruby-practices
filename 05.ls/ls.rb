#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def get_items(glob_pattern)
  Dir.chdir(ARGV[0] && Dir.exist?(ARGV[0]) ? ARGV[0] : '.')
  Dir.glob(glob_pattern).sort
end

def get_string_space(string, width)
  string = string.force_encoding(Encoding::UTF_8) if string != ''
  string_replace_half_width_katakana = string.gsub(/[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｯｧｨｩｪｫｬｭｮﾞﾟ]/u, '*')
  string_width = string_replace_half_width_katakana.each_char.sum do |c|
    c.bytesize == 1 ? 1 : 2
  end
  string + (' ' * (width - string_width))
end

cols = 3
col_width = 30
glob_pattern = '*'

parser = OptionParser.new
parser.on('-a', 'List files including hidden files') do
  glob_pattern = '{*,.*}'
end
parser.parse!

items = get_items(glob_pattern)
rows = (items.count / cols.to_f).ceil(0)

rows.times do |r|
  cols.times do |c|
    printf(get_string_space(items[r + (c * rows)].to_s, col_width))
  end
  puts
end
