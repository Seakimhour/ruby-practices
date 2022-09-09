#!/usr/bin/env ruby
# frozen_string_literal: true

path = ARGV[0] && Dir.exist?(ARGV[0]) ? ARGV[0] : '.'
cols = 3
col_width = 30

def get_items(path)
  Dir.chdir(path)
  items = Dir.glob("*")
  items.sort
end

items = get_items(path)
rows = (items.count / cols.to_f).ceil(0)

def get_string_space(string, width)
  string = string.force_encoding(Encoding::UTF_8) if string != ''
  string_replace_half_width_katakana = string.gsub(/[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｯｧｨｩｪｫｬｭｮﾞﾟ]/u, '*')
  string_width = string_replace_half_width_katakana.each_char.sum do |c|
    c.bytesize == 1 ? 1 : 2
  end
  string + (' ' * (width - string_width))
end

rows.times do |r|
  cols.times do |c|
    printf(get_string_space(items[r + (c * rows)].to_s, col_width))
  end
  puts
end
