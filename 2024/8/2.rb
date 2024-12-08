@grid = []
@antenas = {}

File.open('./input.txt').each_with_index do |input, y|
  row = []

  input.strip.chars.each_with_index do |char, x|
    frequency = char != '.' ? char : nil

    if frequency
      @antenas[frequency] ||= []
      @antenas[frequency] << {x:, y:, frequency: }
    end

    row << {x:, y:, antinode_count: 0, frequency: }
  end

  @grid << row
end

@width = @grid.first.count
@height = @grid.count

@antinode_grid = {}

def add_antinode antinode
  return if antinode[:x] < 0 || antinode[:x] >= @width
  return if antinode[:y] < 0 || antinode[:y] >= @height

  @antinode_grid[antinode[:y]] ||= {}
  @antinode_grid[antinode[:y]][antinode[:x]] = 1
end

@antenas.values.each do |antenas_for_frequency|
  antenas_for_frequency.combination(2).each do |pair|
    distance_x = pair[1][:x] - pair[0][:x]
    distance_y = pair[1][:y] - pair[0][:y]

    x, y = pair[0][:x], pair[0][:y]
    delta_x, delta_y = 0, 0

    while x >= 0 && x < @width && y >= 0 && y < @height
      x -= delta_x
      y -= delta_y

      add_antinode({x:, y:})

      delta_x = distance_x
      delta_y = distance_y
    end

    x, y = pair[1][:x], pair[1][:y]
    delta_x, delta_y = 0, 0

    while x >= 0 && x < @width && y >= 0 && y < @height
      x += delta_x
      y += delta_y

      add_antinode({x:, y:})

      delta_x = distance_x
      delta_y = distance_y
    end
  end
end

@height.times do |y|
  @width.times do |x|
    anti = @antinode_grid.dig(y, x)
    print anti ? '#' : (@grid[y][x][:frequency] || '.')
  end
  puts
end

result = @antinode_grid.values.map(&:values).flatten.sum
puts "result = #{result}"

