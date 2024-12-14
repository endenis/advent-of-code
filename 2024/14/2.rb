modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip

regex = /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/

robots = input.scan(regex).map do |line|
  x, y, vx, vy = line.map(&:to_i)
  {x:, y:, vx:, vy:}
end

width = modifier.nil? ? 101 : 11
height = modifier.nil? ? 103 : 7

seconds = 10_000

matrices = []

middle_x = width / 2
middle_y = height / 2

quadrant_stats = []

(seconds + 1).times do |iteration|
  puts "iteration #{iteration} / #{seconds}"
  matrix = {}
  quadrant1, quadrant2, quadrant3, quadrant4 = 0, 0, 0, 0

  robots.each do |robot|
    x = (robot[:x] + iteration * robot[:vx]) % width
    y = (robot[:y] + iteration * robot[:vy]) % height

    matrix[y] ||= {}
    matrix[y][x] ||= 0
    matrix[y][x] += 1

    if x < middle_x && y < middle_y
      quadrant1 += 1
    elsif y < middle_y && x > middle_x
      quadrant2 += 1
    elsif y > middle_y && x < middle_x
      quadrant3 += 1
    elsif y > middle_y && x > middle_x
      quadrant4 += 1
    end
  end

  all = [quadrant1, quadrant2, quadrant3, quadrant4]
  quadrant_stats << {iteration:, all:}
  matrices << matrix
end

# Find the iteration that had largest concentration of bots in one quadrant

max = 0
index = 0

quadrant_stats.each do
  if _1[:all].max > max
    max = _1[:all].max
    index = _1[:iteration]
  end
end

solution_matrix = matrices[index]

height.times do |j|
  width.times do |i|
    if solution_matrix.dig(j, i)
      print 'X'
    else
      print ' '
    end
  end
  puts
end

puts "result = #{index}"
