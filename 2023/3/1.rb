lines = []

symbol_regexp = /[\$\%\+\*\#\&\=\/\-\@]/

i = 0
File.open('./input.txt').each do |input|
  input_line = input.strip

  chars = input_line.split('')

  line = []

  chars.each.with_index do |char, j|
    if char =~ symbol_regexp
      line << { type: :symbol, i:, j: }
    elsif char == '.'
      line << { type: :empty, i:, j: }
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

    if j > 0
      if line[j - 1][:type] == :digit
        has_neigbouring_symbol = line[j - 1][:has_neigbouring_symbol]
      elsif line[j - 1][:type] == :symbol
        has_neigbouring_symbol = true
      end
    end

    unless has_neigbouring_symbol
      has_neigbouring_symbol = j < line_length - 1 && line[j + 1][:type] == :symbol
    end

    unless has_neigbouring_symbol
      lines_to_check = []
      lines_to_check << i - 1 if i > 0
      lines_to_check << i + 1 if i < lines_count - 1

      left_boundary = [0, (j - 1)].max
      right_boundary = [(j + 1), line_length - 1].min

      lines_to_check.each do |k|
        has_neigbouring_symbol = lines[k][left_boundary..right_boundary].any? { _1[:type] == :symbol }

        break if has_neigbouring_symbol
      end
    end

    lines[i][j][:has_neigbouring_symbol] = has_neigbouring_symbol

    if lines[i][j][:is_last]
      if has_neigbouring_symbol
        part_numbers << lines[i][j][:value]
      else
        not_part_numbers << lines[i][j][:value]
      end
    end
  end
end

result = part_numbers.sum
puts "Result: #{result}"
