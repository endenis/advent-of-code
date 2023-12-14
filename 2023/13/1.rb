# Launch the file as:
# ruby 1.rb test
# or
# ruby 1.rb

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

def get_column(section, x)
  height = section.count

  (0...height).map { |y| section[y][x] }
end

def find_mirror(rows)
  row_mirror = nil
  width = rows.count
  (1...width).each do |i|
    if rows[i] == rows[0]
      subset = rows[0..i]
      next if subset.count.odd?

      subset_center = subset.count / 2
      left, right = subset[0...subset_center], subset[subset_center..i]

      if left == right.reverse
        row_mirror = subset_center
        break
      end
    end
  end

  return row_mirror if row_mirror

  (1...width).each do |i|
    position = width - 1 - i
    if rows[position] == rows[width - 1]
      subset = rows[position..]
      next if subset.count.odd?

      subset_center = subset.count / 2
      left, right = subset[0...subset_center], subset[subset_center..]
      if left == right.reverse
        row_mirror = width - subset_center
        break
      end
    end
  end

  row_mirror
end

sum = 0

parsed_data = data.map do |section|
  rows = section.map { |row| row.join.to_i(2) }

  width = section.first.count
  columns = (0...width).map do |x|
    get_column(section, x).join.to_i(2)
  end

  row_mirror = find_mirror(rows)
  column_mirror = find_mirror(columns)

  sum += row_mirror.to_i * 100 + column_mirror.to_i

  { rows:, columns:, row_mirror:, column_mirror: }
end

result = sum
puts "Result: #{result}"
