# frozen_string_literal: true

class ShortPrinter
  
  NUMBER_OF_COLUMN = 3
  COLUMN_WIDTH = 30

  def print_output(files)
    number_of_row = (files.count / NUMBER_OF_COLUMN.to_f).ceil
    number_of_row.times do |row|
      NUMBER_OF_COLUMN.times do |column|
        printf(get_string(files[row + column * number_of_row].to_s))
      end
      puts
    end
  end

  def get_string(string)
    string = string.force_encoding(Encoding::UTF_8) if string != ''
    string_without_half_width_katakana = string.gsub(/[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｯｧｨｩｪｫｬｭｮﾞﾟ]/u, '*')
    string_width = string_without_half_width_katakana.chars.map { |char| char.bytesize == 1 ? 1 : 2 }.sum
    string + ' ' * (COLUMN_WIDTH - string_width)
  end
end