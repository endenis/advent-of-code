modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip

regex = /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/

robots = input.scan(regex).map do |line|
  x, y, vx, vy = line.map(&:to_i)
  {x:, y:, vx:, vy:}
end

width = modifier.nil? ? 101 : 11
height = modifier.nil? ? 103 : 7

seconds = 100

robots.each do |robot|
  robot[:x] += seconds * robot[:vx]
  robot[:x] = robot[:x] % width

  robot[:y] += seconds * robot[:vy]

  robot[:y] = robot[:y] % height
end

quadrant1, quadrant2, quadrant3, quadrant4 = 0, 0, 0, 0

middle_x = width / 2
middle_y = height / 2

height.times do |j|
  next if j == middle_y

  width.times do |i|
    next if i == middle_x

    robot_count = robots.count { _1[:x] == i && _1[:y] == j }

    if i < middle_x && j < middle_y
      quadrant1 += robot_count
    elsif j < middle_y && i > middle_x
      quadrant2 += robot_count
    elsif j > middle_y && i < middle_x
      quadrant3 += robot_count
    elsif j > middle_y && i > middle_x
      quadrant4 += robot_count
    end
  end
end

result = [quadrant1, quadrant2, quadrant3, quadrant4].reduce(:*)
puts "result = #{result}"
