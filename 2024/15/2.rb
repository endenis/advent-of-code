modifier = ".#{ARGV[0]}" if ARGV[0]

@matrix = []
robot_movements = []
robot_position = nil
parsing_map = true

File.open("./input#{modifier}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  if input_line.empty?
    parsing_map = false
    next
  end

  doubled_input_line = input_line.gsub('.', '..').gsub('#', '##').gsub('O', '[]').gsub('@', '@.')

  split_input_line = doubled_input_line.split('')

  if parsing_map
    @matrix << split_input_line
    
    unless robot_position
      x = split_input_line.index '@'
      robot_position = [@matrix.count - 1, x] if x
    end
  else
    robot_movements += split_input_line
  end
end

@width = @matrix.first.count
@height = @matrix.count

@height.times do |y|
  @width.times do |x|
    print @matrix[y][x]
  end
  puts
end

def direction(move)
  case move
  when '<'
    [0, -1]
  when '^'
    [-1, 0]
  when '>'
    [0, 1]
  when 'v'
    [1, 0]
  end
end

@horizontal_moves = ['<', '>'].freeze

def compute_movable_things(y:, x:, move:)
  thing = @matrix[y][x]

  return if thing == '#'
  return [] if thing == '.'

  delta_y, delta_x = direction(move)
  new_y = y + delta_y
  new_x = x + delta_x

  if @horizontal_moves.include?(move)
    next_movables = compute_movable_things(y: new_y, x: new_x, move:)
    if next_movables.nil?
      nil
    else
      [[y, x]] + next_movables
    end
  else
    side_offest =
      if thing == '['
        1
      elsif thing == ']'
        -1
      else
        raise "Unknown char for side offset: #{thing} at (#{y}, #{x})"
      end

    next_movables = compute_movable_things(y: new_y, x: new_x, move:)
    return nil if next_movables.nil?

    next_side_movables = compute_movable_things(y: new_y, x: new_x + side_offest, move:)
    return nil if next_side_movables.nil?

    [[y, x], [y, x + side_offest]] + next_movables + next_side_movables
  end
end

puts

length = robot_movements.count

robot_movements.each_with_index do |move, i|
  puts "move #{i + 1} / #{length}: #{move}"

  y, x = robot_position
  delta_y, delta_x = direction(move)

  new_y = y + delta_y
  new_x = x + delta_x

  case @matrix[new_y][new_x]
  when '.'
    @matrix[y][x] = '.'
    robot_position = [new_y, new_x]
    @matrix[new_y][new_x] = '@'
  when '#'
    # nothing
  when '[', ']'
    list_of_things_to_move = compute_movable_things(y: new_y, x: new_x, move:)
    next if list_of_things_to_move.nil?

    list_of_things_to_move.reverse.uniq.each do |box_y, box_x|
      @matrix[box_y + delta_y][box_x + delta_x] = @matrix[box_y][box_x]
      @matrix[box_y][box_x] = '.'
    end

    @matrix[y][x] = '.'
    robot_position = [new_y, new_x]
    @matrix[new_y][new_x] = '@'
  else
    raise "Unknown obstacle: '#{@matrix[new_y][new_x]}' at y = #{new_y}, x = #{new_x}"
  end
end

result = 0

puts
@height.times do |y|
  @width.times do |x|
    if @matrix[y][x] == '['
      result += 100 * y + x
    end

    print @matrix[y][x]
  end
  puts
end

puts
puts "result = #{result}"
