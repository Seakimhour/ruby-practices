#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

parser = OptionParser.new
parser.on('-a', 'List files including hidden files')
options = {path: '.'}
parser.parse!(into: options)
options[:path] = parser.parse![0] if parser.parse![0] && Dir.exist?(parser.parse![0]) 

cols = 3
col_width = 30

def get_items(options)
  Dir.chdir(options[:path])
  items = options[:a] ? Dir.glob("*", File::FNM_DOTMATCH) : Dir.glob("*")
  items.sort
end

items = get_items(options)
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
