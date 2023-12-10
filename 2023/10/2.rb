require 'colorize'
require 'perfect-shape'

# Launch the file as:
# ruby 2.rb test2
# or
# ruby 2.rb

@data = []
test_suffix = %w[test test2 test3].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

i = 0
s_position = {}

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip
  @data << input_line.split('')

  s_position = {x: input_line.index('S'), y: i, value: 'S'} if s_position[:x].nil?

  i += 1
end

current_position = nil

# Checking position around S like:
# .1.
# 4S2
# .3.

@valid_connections = {
  top: ['|', 'F', '7'],
  right: ['-', '7', 'J'],
  bottom: ['|', 'J', 'L'],
  left: ['-', 'F', 'L'],
}

def valid_pipe_connection?(direction, value)
  @valid_connections[direction].include? value
end

def find_in_data(x:, y:)
  value = @data[y][x]
  {x:, y:, value:}
end

# Position 1
if s_position[:y] > 0
  new_position = find_in_data(x: s_position[:x], y: s_position[:y] - 1)

  current_position = new_position if valid_pipe_connection?(:top, new_position[:value])
end

# Position 2
if current_position.nil? && s_position[:x] < @data[s_position[:y]].count - 1
  new_position = find_in_data(x: s_position[:x] + 1, y: s_position[:y])

  current_position = new_position if valid_pipe_connection?(:right, new_position[:value])
end

# Position 3
if current_position.nil? && s_position[:y] < @data.count - 1
  new_position = find_in_data(x: s_position[:x], y: s_position[:y] + 1)

  current_position = new_position if valid_pipe_connection?(:bottom, new_position[:value])
end

# Position 4
if current_position.nil? && s_position[:x] > 0
  new_position = find_in_data(x: s_position[:x] - 1, y: s_position[:y])

  current_position = new_position if valid_pipe_connection?(:left, new_position[:value])
end

history = [s_position]

while current_position[:value] != 'S'
  previous = history.last
  history << current_position

  case current_position[:value]
  when '|'
    x_offset = 0
    y_offset = previous[:y] < current_position[:y] ? 1 : -1
  when '-'
    x_offset = previous[:x] < current_position[:x] ? 1 : -1
    y_offset = 0
  when 'L'
    x_offset = previous[:x] > current_position[:x] ? 0 : 1
    y_offset = previous[:y] < current_position[:y] ? 0 : -1
  when 'J'
    x_offset = previous[:x] < current_position[:x] ? 0 : -1
    y_offset = previous[:y] < current_position[:y] ? 0 : -1
  when '7'
    x_offset = previous[:x] < current_position[:x] ? 0 : -1
    y_offset = previous[:y] > current_position[:y] ? 0 : 1
  when 'F'
    x_offset = previous[:x] > current_position[:x] ? 0 : 1
    y_offset = previous[:y] > current_position[:y] ? 0 : 1
  else
    raise "Unknown value #{current_position.inspect}"
  end

  current_position = find_in_data(x: current_position[:x] + x_offset, y: current_position[:y] + y_offset)
  current_position[:is_pipe] = true
end

history.each do |position|
  @data[position[:y]][position[:x]] = position[:value].blue
end

points = history.map { [_1[:x], _1[:y]] }
shape = PerfectShape::Polygon.new(points:)

result = 0

@data.each_with_index do |row, y|
  row.each_with_index do |value, x|
    point = [x, y]
    if !value.colorized? && shape.contain?(point, outline: false)
      print value.green
      result += 1
    else
      print value
    end
  end
  puts
end

puts "Result: #{result}"
