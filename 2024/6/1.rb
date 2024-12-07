@map = []

start_pos = {x: nil, y: nil}
initial_direction = :up

File.open('./input.txt').each_with_index do |input, i|
  line = input.strip.split('')

  j = line.find_index('^')
  if j
    start_pos = {x: j, y: i}
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

  if @map[next_pos[:y]][next_pos[:x]] == '#'
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

result = 0
@height.times do |y|
  @width.times do |x|
    if visited.find { |point| point[:x] == x && point[:y] == y }
      result += 1
      print 'X'
    else
      print @map[y][x]
    end
  end
  puts
end

puts "result = #{result}"
