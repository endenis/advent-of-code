# Launch the file as:
# ruby 2.rb test
# or
# ruby 2.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

@table = []

EMPTY_CELL = '.'.freeze
VERTICAL_CELL = '|'.freeze
HORIZONTAL_CELL = '-'.freeze
LEFT_CELL = '/'.freeze
RIGHT_CELL = '\\'.freeze

y = 0
File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  @table << input_line.chars.map.with_index do |value, x|
    {
      value:,
      x:,
      y:,
      history: [],
    }
  end

  y += 1
end

def draw_table(visits_only: false)
  @table.each do |row|
    row.each do |cell|
      if visits_only
        print cell[:history].count != 0 ? '#' : EMPTY_CELL
      else
        print cell[:value]
      end
    end
    puts
  end
end

@width = @table.first.count
@height = @table.count

def get_next_cell(next_pos)
  x = next_pos[:x]
  y = next_pos[:y]

  return if x < 0 || y < 0
  return if x >= @width || y >= @height

  @table[y][x]
end

def get_next_pos(cell, direction)
  case direction
  when :top
    next_pos = {x: cell[:x], y: cell[:y] - 1}
  when :right
    next_pos = {x: cell[:x] + 1, y: cell[:y]}
  when :bottom
    next_pos = {x: cell[:x], y: cell[:y] + 1}
  when :left
    next_pos = {x: cell[:x] - 1, y: cell[:y]}
  else
    raise "Cannot get next position with direction #{direction} for #{cell.inspect}"
  end

  next_pos
end

def light_pass(cell, direction)
  return if cell[:history].include?(direction)

  cell[:history] << direction

  # . with any direction or |- without perpendicular direction
  if cell[:value] == EMPTY_CELL ||
    (cell[:value] == VERTICAL_CELL && [:top, :bottom].include?(direction)) ||
    (cell[:value] == HORIZONTAL_CELL && [:left, :right].include?(direction))
    next_pos = get_next_pos cell, direction
    next_cell = get_next_cell next_pos
  # /
  elsif cell[:value] == LEFT_CELL
    case direction
    when :top
      direction = :right
    when :right
      direction = :top
    when :bottom
      direction = :left
    when :left
      direction = :bottom
    end

    next_pos = get_next_pos cell, direction
    next_cell = get_next_cell next_pos
  # \
  elsif cell[:value] == RIGHT_CELL
    case direction
    when :top
      direction = :left
    when :right
      direction = :bottom
    when :bottom
      direction = :right
    when :left
      direction = :top
    end

    next_pos = get_next_pos cell, direction
    next_cell = get_next_cell next_pos
  # >|<
  elsif cell[:value] == VERTICAL_CELL
    if [:left, :right].include? direction
      top_cell_pos = get_next_pos cell, :top
      top_cell = get_next_cell top_cell_pos

      light_pass(top_cell, :top) if top_cell

      bottom_cell_pos = get_next_pos cell, :bottom
      bottom_cell = get_next_cell bottom_cell_pos

      light_pass(bottom_cell, :bottom) if bottom_cell
    else
      raise "Bad direction #{direction} at #{cell.inspect}"
    end
  # v
  # -
  # ^
  elsif cell[:value] == HORIZONTAL_CELL
    if [:top, :bottom].include? direction
      left_cell_pos = get_next_pos cell, :left
      left_cell = get_next_cell left_cell_pos

      light_pass(left_cell, :left) if left_cell

      right_cell_pos = get_next_pos cell, :right
      right_cell = get_next_cell right_cell_pos

      light_pass(right_cell, :right) if right_cell
    else
      raise "Bad direction #{direction} at #{cell.inspect}"
    end
  end

  return unless next_cell

  light_pass next_cell, direction
end

def count_lit_cells
  @table.sum do |row|
    row.count { _1[:history].count > 0 }
  end
end

lit_counts = []
@original_table = @table

def reset_table
  @table = @original_table.map do |row|
    row.map do |cell|
      cell.dup.tap { |new_cell| new_cell[:history] = [] }
    end
  end
end

puts "Initial table:"
draw_table

# It's probably possible to optimise this further but the input is small enough to ignore it.

(0...@height).each do |y|
  first_x = 0
  last_x = @width - 1

  light_pass @table[y][first_x], :right
  lit_counts << count_lit_cells
  reset_table

  light_pass @table[y][last_x], :left
  lit_counts << count_lit_cells
  reset_table
end

(0...@width).each do |x|
  first_y = 0
  last_y = @height - 1

  light_pass @table[first_y][x], :bottom
  lit_counts << count_lit_cells
  reset_table

  light_pass @table[last_y][x], :top
  lit_counts << count_lit_cells
  reset_table
end

result = lit_counts.max
puts "Result: #{result}"
