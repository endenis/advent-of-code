# Is this solution slow? - Yes
# Does it work? - Yes

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

# @all_points = {}
@distances = {}

@height.times do |y|
  @width.times do |x|
    print @matrix[y][x]
    if @matrix[y][x] != '#'
      @distances[[y, x]] = {paths: []}
    end
  end
  puts
end

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

def opposite_direction(direction)
  {
    up: :down,
    right: :left,
    down: :up,
    left: :right,
  }[direction]
end

@visited = {}

@all_points = [[start_position, :right]]

@distances[start_position] = {
  paths: [{
    path: [[start_position, :right]],
    cost: 0,
  }],
  min_cost: 0,
}

@cost_limit_from_part1 = 102460

def clean_paths!(data_point)
  minimums = Hash.new(Float::INFINITY)
  minimum = Float::INFINITY

  data_point[:paths].each do |entry|
    path_direction = entry[:path].last.last
    minimum = entry[:cost] if entry[:cost] < minimum
    minimums[path_direction] = entry[:cost] if entry[:cost] < minimums[path_direction]
  end

  data_point[:paths].delete_if do |entry|
    path_direction = entry[:path].last.last
    entry[:cost] > minimums[path_direction] || entry[:cost] > @cost_limit_from_part1
  end

  data_point[:min_cost] = minimum
end

i = 0
while !@all_points.empty?
  current_point = @all_points.shift
  current_position, current_direction = current_point

  puts "i = #{i}, current_point = #{current_point.inspect}. Path count = #{@distances[current_position][:paths].count}" if i % 100 == 0

  min_cost = @distances[current_position][:min_cost]
  next if @visited[current_position] && @visited[current_position] < min_cost

  @visited[current_position] = min_cost

  y, x = current_position

  next_points = [
    [[y - 1, x], :up],
    [[y, x + 1], :right],
    [[y + 1, x], :down],
    [[y, x - 1], :left],
  ]

  next_points.each do |next_position, next_direction|
    next if @matrix[next_position[0]][next_position[1]] == '#'

    key = [next_position, next_direction]

    next unless @distances[next_position]

    paths = @distances[current_position][:paths].map do
      path_direction = _1[:path].last.last

      next_cost = _1[:cost] + compute_cost(current_direction: path_direction, move_direction: next_direction)

      @all_points << key if (!@visited[next_position] || @visited[next_position] > next_cost)

      {path: _1[:path] + [key], cost: next_cost}
    end

    @distances[next_position][:paths] += paths

    min_cost = @distances[next_position][:paths].map { _1[:cost] }.min
    @distances[next_position][:min_cost] = min_cost

    @distances[next_position][:paths].uniq!
    clean_paths!(@distances[next_position])
    @all_points.uniq!
  end

  i += 1
end

min_cost = @distances[end_position][:paths].map { _1[:cost] }.min

good_positions = @distances[end_position][:paths].select { _1[:cost] == min_cost }.map { _1[:path] }.flatten(1).map(&:first).uniq

puts "min_cost = #{min_cost}"

@height.times do |y|
  @width.times do |x|
    print good_positions.include?([y, x]) ? 'O' : @matrix[y][x]
  end
  puts
end

result = good_positions.count
puts "result = #{result}"
