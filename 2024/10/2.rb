modifier = ".#{ARGV[0]}" if ARGV[0]
filename = "./input#{modifier}.txt"

@grid = []
zeros = []

File.open(filename).each_with_index do |raw_input_line, j|
  line = raw_input_line.strip.split('').map { _1 == '.' ? '.' : _1.to_i }
  @grid << line

  line.each_with_index do |entry, i|
    next if entry != 0

    zeros << [j, i]
  end
end

@width = @grid.first.count
@height = @grid.count

def out_of_bounds?(y, x)
  x < 0 || x >= @width || y < 0 || y >= @height
end

@cache = {}

def compute_for_branch(y, x, new_y, new_x, path)
  return if out_of_bounds?(new_y, new_x)
  return if @grid[new_y][new_x] == '.'
  return if @grid[new_y][new_x] - @grid[y][x] != 1
  return if path.include?([new_y, new_x])

  compute_for(new_y, new_x, path)
end

def compute_for(y, x, path)
  current_value = @grid[y][x]
  new_path = path + [[y, x]]

  if current_value == 9
    @paths << new_path
    return
  end

  compute_for_branch(y, x, y - 1, x, new_path)
  compute_for_branch(y, x, y, x - 1, new_path)
  compute_for_branch(y, x, y, x + 1, new_path)
  compute_for_branch(y, x, y + 1, x, new_path)
end

result = zeros.sum do |trailhead|
  y, x = trailhead

  @cache = {}
  @paths = []
  compute_for(y, x, [])

  @paths.uniq.count
end

puts "result = #{result}"
