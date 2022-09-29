#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def get_string_space(string, width)
  string = string.force_encoding(Encoding::UTF_8) if string != ''
  string_replace_half_width_katakana = string.gsub(/[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｯｧｨｩｪｫｬｭｮﾞﾟ]/u, '*')
  string_width = string_replace_half_width_katakana.each_char.sum do |c|
    c.bytesize == 1 ? 1 : 2
  end
  string + (' ' * (width - string_width))
end

def readable_permisions(file_name)
  permissions = {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x'
  }

  (File.directory?(file_name) ? 'd' : '-') + format('%o', File.stat(file_name).mode)[-3..].chars.map { |digit| permissions[digit] }.join
end

def item_long_format(path, item)
  file_name = "#{path}/#{item}"

  file = File.stat(file_name)

  item_long_format = readable_permisions(file_name)
  item_long_format << format(' %3s', file.nlink)
  item_long_format << format(' %15s', Etc.getpwuid(file.uid).name)
  item_long_format << format(' %15s', Etc.getgrgid(file.gid).name)
  item_long_format << format(' %8s', file.size)
  item_long_format << format(' %s', file.ctime.ctime)
  item_long_format << format(' %s', item)
end

cols = 3
col_width = 30
options = {
  path: '.',
  hidden_files: 0,
  reverse: false,
  long_format: false
}

parser = OptionParser.new
parser.on('-a', 'List files including hidden files') do
  options[:hidden_files] = File::FNM_DOTMATCH
end
parser.on('-r', 'Reverse the sorting order') do
  options[:reverse] = true
end
parser.on('-l', 'List files in long format') do
  options[:long_format] = true
end
parser.parse!

# Change path if argv and directory exist
options[:path] = ARGV[0] if ARGV[0] && Dir.exist?(ARGV[0])

items = Dir.glob('*', options[:hidden_files], base: options[:path]).sort
items.reverse! if options[:reverse]

if options[:long_format]
  items.count do |item|
    puts item_long_format(options[:path], item)
  end
else
  rows = (items.count / cols.to_f).ceil
  rows.times do |r|
    cols.times do |c|
      printf(get_string_space(items[r + (c * rows)].to_s, col_width))
    end
    puts
  end
end
