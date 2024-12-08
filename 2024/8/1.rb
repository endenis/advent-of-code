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

    first_antinode = {x: pair[0][:x] - distance_x, y: pair[0][:y] - distance_y}
    second_antinode = {x: pair[1][:x] + distance_x, y: pair[1][:y] + distance_y}

    add_antinode first_antinode
    add_antinode second_antinode
  end
end

result = @antinode_grid.values.map(&:values).flatten.sum
puts "result = #{result}"
