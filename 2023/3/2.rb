lines = []

symbol_regexp = /[\$\%\+\*\#\&\=\/\-\@]/

i = 0
File.open('./input.txt').each do |input|
  input_line = input.strip

  chars = input_line.split('')

  line = []

  chars.each.with_index do |char, j|
    if char =~ symbol_regexp
      line << { type: :symbol, i:, j:, value: char, is_star: (char == '*') }
    elsif char == '.'
      line << { type: :empty, i:, j:, value: char }
    elsif char =~ /\d/
      if j != 0 && line[j - 1][:type] == :digit
        base_value = line[j - 1][:value] * 10
        line[j - 1][:is_last] = false
      end

      line << {
        type: :digit,
        i:,
        j:,
        value: base_value.to_i + char.to_i,
        is_last: true,
      }
    else
      raise "Unknown symbol: #{char}"
    end
  end

  lines << line

  i += 1
end

lines_count = lines.count

part_numbers = []
not_part_numbers = []

lines.each_with_index do |line, i|
  line_length = line.count

  line_length.times do |j|
    next if lines[i][j][:type] != :digit

    has_neigbouring_symbol = false
    neigbouring_stars = []

    if j > 0
      if line[j - 1][:type] == :digit
        has_neigbouring_symbol = line[j - 1][:has_neigbouring_symbol]
        neigbouring_stars += line[j - 1][:neigbouring_stars]
      elsif line[j - 1][:type] == :symbol
        has_neigbouring_symbol ||= true

        if line[j - 1][:is_star]
          neigbouring_stars << [i, j - 1]
        end
      end
    end

    if j < line_length - 1 && line[j + 1][:type] == :symbol
      has_neigbouring_symbol ||= true

      if line[j + 1][:is_star]
        neigbouring_stars << [i, j + 1]
      end
    end

    lines_to_check = []
    lines_to_check << i - 1 if i > 0
    lines_to_check << i + 1 if i < lines_count - 1

    left_boundary = [0, (j - 1)].max
    right_boundary = [(j + 1), line_length - 1].min

    lines_to_check.each do |k|
      lines[k][left_boundary..right_boundary].each do |entry|
        has_neigbouring_symbol ||= entry[:type] == :symbol

        if entry[:is_star]
          neigbouring_stars << [entry[:i], entry[:j]]
        end
      end
    end

    lines[i][j][:has_neigbouring_symbol] = has_neigbouring_symbol
    lines[i][j][:neigbouring_stars] = neigbouring_stars

    if lines[i][j][:is_last]
      if has_neigbouring_symbol
        part_numbers << lines[i][j]
      else
        not_part_numbers << lines[i][j]
      end
    end
  end
end

stars = {}

part_numbers.each do |entry|
  entry[:neigbouring_stars].uniq.each do |star_position|
    stars[star_position] ||= []
    stars[star_position] << entry[:value]
  end
end

gears = stars.select { |key, value| value.count == 2 }

result = gears.values.map { _1.reduce(:*) }.sum

puts "Result: #{result}"
