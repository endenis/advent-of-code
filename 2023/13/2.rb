# Launch the file as:
# ruby 2.rb test
# or
# ruby 2.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

data = []

current_section = []

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  if input_line.empty?
    data << current_section
    current_section = []

    next
  end

  current_section << input_line.split('').map { |char| char == '#' ? '1' : '0' }
end
data << current_section

def count_differences(a, b)
  differences = 0

  a.each_with_index do |element, index|
    differences += 1 if element != b[index]
  end

  differences
end

def get_column(section, x)
  height = section.count

  (0...height).map { |y| section[y][x] }
end

def find_mirror(table)
  position = nil
  width = table.count

  width.times do |i|
    left_i = i
    right_i = left_i + 1
 
    valid_mirror = true
    smudge_used = false
    while left_i >= 0 && right_i < width
      differences = count_differences table[left_i], table[right_i]

      if differences == 1
        if !smudge_used
          smudge_used = true
        else
          valid_mirror = false
          break
        end
      elsif differences > 1
        valid_mirror = false
        break
      end

      # Move in both directions
      left_i -= 1
      right_i += 1
    end

    next unless valid_mirror
    next unless smudge_used
 
    position = i + 1
  end

  position.to_i
end

sum = 0

parsed_data = data.map do |section|
  @smudge_used = false

  rows = section.map { |row| row }

  width = section.first.count
  # Here I transpose the matrix
  columns = (0...width).map do |x|
    get_column(section, x)
  end

  row_mirror = find_mirror(rows)
  column_mirror = find_mirror(columns)

  sum += row_mirror.to_i * 100 + column_mirror.to_i

  { rows:, columns:, row_mirror:, column_mirror: }
end

result = sum
puts "Result: #{result}"


