modifier = ".#{ARGV[0]}" if ARGV[0]

@matrix = []

start_position = nil
end_position = nil

File.open("./input#{modifier}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip.split('')
  @matrix << input_line

  unless start_position
    start_index = input_line.index('S')
    start_position = [@matrix.count - 1, start_index] if start_index
  end

  unless end_position
    end_index = input_line.index('E')
    end_position = [@matrix.count - 1, end_index] if end_index
  end
end

@width = @matrix.first.count
@height = @matrix.count

@all_points = {}
@distances = {}

@height.times do |y|
  @width.times do |x|
    print @matrix[y][x]
    if @matrix[y][x] != '#'
      @all_points[[y, x]] = Float::INFINITY
      @distances[[y, x]] = {distance: Float::INFINITY, direction: nil}
    end
  end
  puts
end

@all_points[start_position] = 0
@distances[start_position] = {distance: 0, direction: :right}

def compute_cost(current_direction:, move_direction:)
  {
    up: {
      up: 1,
      right: 1001,
      down: 2001,
      left: 1001,
    },
    right: {
      up: 1001,
      right: 1,
      down: 1001,
      left: 2001,
    },
    down: {
      up: 2001,
      right: 1001,
      down: 1,
      left: 1001,
    },
    left: {
      up: 1001,
      right: 2001,
      down: 1001,
      left: 1,
    },
  }.dig(current_direction, move_direction)
end

while !@all_points.empty?
  puts "#{@all_points.count} / #{@distances.count}" if @all_points.count % 100 == 0

  current_position = @all_points.sort { |a, b| a.last <=> b.last }.first.first
  @all_points.delete(current_position)

  current_data = @distances[current_position]
  current_distance = current_data[:distance]
  current_direction = current_data[:direction]

  y, x = current_position

  next_points = [
    [[y - 1, x], current_distance + compute_cost(current_direction:, move_direction: :up), :up],
    [[y, x + 1], current_distance + compute_cost(current_direction:, move_direction: :right), :right],
    [[y + 1, x], current_distance + compute_cost(current_direction:, move_direction: :down), :down],
    [[y, x - 1], current_distance + compute_cost(current_direction:, move_direction: :left), :left],
  ]

  next_points.each do |next_position, next_cost, next_direction|
    @all_points[next_position] = next_cost if @all_points[next_position] && @all_points[next_position] > next_cost
    @distances[next_position] = {distance: next_cost, direction: next_direction} if @distances[next_position] && @distances[next_position][:distance] > next_cost
  end
end

result = @distances.dig(end_position, :distance)

puts "result = #{result}"
