require 'colorize'

# Launch the file as:
# ruby 1.rb test
# or
# ruby 1.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

table = []
galaxy_positions = []

File.open("./input#{test_suffix}.txt").each_with_index do |raw_input_line, y|
  input_line = raw_input_line.strip
  row = []

  input_line.split('').each_with_index do |char, x|
    row << char

    galaxy_positions << {x:, y:} if char == '#'
  end

  table << row
end

rows_to_duplicate = []
columns_to_duplicate = []

table.each_with_index do |row, y|
  rows_to_duplicate << y if row.all?('.')
end

table[0].count.times do |x|
  if table.all? { _1[x] == '.' }
    columns_to_duplicate << x
  end
end

rows_to_duplicate.sort.reverse.each do |y|
  new_row = table[y].dup
  table.insert(y, new_row)

  galaxy_positions.each do |galaxy_position|
    galaxy_position[:y] += 1 if galaxy_position[:y] > y
  end
end

columns_to_duplicate.sort.reverse.each do |x|
  table.each do |row|
    row.insert(x, '.')
  end

  galaxy_positions.each do |galaxy_position|
    galaxy_position[:x] += 1 if galaxy_position[:x] > x
  end
end

table.each do |row|
  row.each do |char|
    print char == '#' ? char.green : char
  end
  puts
end

combinations = galaxy_positions.combination(2).to_a

result = combinations.sum do |left, right|
  (left[:x] - right[:x]).abs + (left[:y] - right[:y]).abs
end

puts "Result: #{result}"
