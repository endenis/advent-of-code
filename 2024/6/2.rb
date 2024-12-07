@map = []

initial_direction = :up
start_pos = {x: nil, y: nil, direction: initial_direction}

File.open('./input.txt').each_with_index do |input, i|
  line = input.strip.split('')

  j = line.find_index('^')
  if j
    start_pos[:y] = i
    start_pos[:x] = j
    line[j] = '.'
  end

  @map << line
end

@width = @map.first.count
@height = @map.count

def turn_right(direction:)
  {
    up: :right,
    right: :bottom,
    bottom: :left,
    left: :up,
  }[direction]
end

def calculate_next_pos(x:, y:, direction:)
  next_pos = 
    case direction
    when :up
      { x:, y: y - 1 }
    when :right
      { x: x + 1, y: }
    when :left
      { x: x  - 1, y: }
    when :bottom
      { x:, y: y + 1 }
    else
      raise "Unknown direction: #{direction}"
    end

  if next_pos[:x] < 0 ||
    next_pos[:y] < 0 ||
    next_pos[:x] >= @width ||
    next_pos[:y] >= @height
    return nil
  end

  if ['#', 'O'].include? @map[next_pos[:y]][next_pos[:x]]
    return calculate_next_pos(x:, y:, direction: turn_right(direction:))
  end

  next_pos.merge(direction:)
end

current_pos = start_pos.merge(direction: initial_direction)
visited = []

while true
  next_pos = calculate_next_pos(**current_pos)
  visited << current_pos
  break if next_pos.nil?

  current_pos = next_pos
end

def loop?(start_pos:)
  current_pos = start_pos.dup
  visited_this_iteration = {}

  while true
    l_next_pos = calculate_next_pos(**current_pos)
    break if l_next_pos.nil?

    return true if visited_this_iteration.dig(l_next_pos[:y], l_next_pos[:x])&.include?(l_next_pos[:direction])

    visited_this_iteration[l_next_pos[:y]] ||= {}
    visited_this_iteration[l_next_pos[:y]][l_next_pos[:x]] ||= []
    visited_this_iteration[l_next_pos[:y]][l_next_pos[:x]] << l_next_pos[:direction]

    current_pos = l_next_pos
  end

  false
end

result = 0

index = 0
size = @width * @height

@height.times do |y|
  @width.times do |x|
    index += 1
    puts "Processing #{index} / #{size}"

    next unless visited.find { _1[:x] == x && _1[:y] == y }
    next if @map[y][x] == '#'

    @map[y][x] = 'O'

    result += 1 if loop?(start_pos:)

    @map[y][x] = '.'
  end
end

puts "result = #{result}"
