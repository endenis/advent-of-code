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

  split_input_line = input_line.split('')

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

# @height.times do |y|
#   @width.times do |x|
#     print @matrix[y][x]
#   end
#   puts
# end

puts

puts robot_movements.inspect
puts

puts "robot position = #{robot_position.inspect}\n\n"

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

def compute_destination(y:, x:, delta_y:, delta_x:)
  y += delta_y
  x += delta_x

  case @matrix[y][x]
  when '.'
    [y, x]
  when 'O'
    compute_destination(y:, x:, delta_y:, delta_x:)
  when '#'
    nil
  else
    raise "Unknown next: '#{@matrix[y][x]}' at y = #{y}, x = #{x}"
  end
end

puts

length = robot_movements.count

robot_movements.each_with_index do |move, i|
  # puts
  # @height.times do |y|
  #   @width.times do |x|
  #     print @matrix[y][x]
  #   end
  #   puts
  # end
  # puts
  puts "move #{i + 1} / #{length}"

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
  when 'O'
    destination = compute_destination(y: new_y, x: new_x, delta_y:, delta_x:)
    if destination
      puts "destination: #{destination.inspect}"
      box_y, box_x = destination
      @matrix[box_y][box_x] = 'O'
      @matrix[y][x] = '.'
      robot_position = [new_y, new_x]
      @matrix[new_y][new_x] = '@'
    else
      "no destination"
    end
  else
    raise "Unknown obstacle: '#{@matrix[new_y][new_x]}' at y = #{new_y}, x = #{new_x}"
  end
end

result = 0

puts
@height.times do |y|
  @width.times do |x|
    if @matrix[y][x] == 'O'
      result += 100 * y + x
    end

    print @matrix[y][x]
  end
  puts
end

puts
puts "result = #{result}"
