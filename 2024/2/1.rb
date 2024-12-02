lines = []

File.open('./input.txt').each do |input|
  lines << input.strip.split(' ').map(&:to_i)
end

result = 0

lines.each do |line|
  next if line[1] == line[0]

  direction = (line[1] - line[0] > 0) ? :increasing : :decreasing

  line_result = true

  line.each_with_index do |number, i|
    next if i == 0

    difference = line[i] - line[i - 1]
    if difference == 0 ||
      difference.abs > 3 ||
      (difference < 0 && direction == :increasing) ||
      (difference > 0 && direction == :decreasing)
      line_result = false
      break
    end
  end

  result += 1 if line_result
end

puts "result = #{result}"
