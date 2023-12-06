data = {}

File.open('./input.txt').each do |input|
  input_line = input.strip
  current_key = nil

  if input_line.start_with? 'Time'
    current_key = :time
  elsif input_line.start_with? 'Distance'
    current_key = :distance
  end

  data[current_key] = input_line.scan(/(\d+)/).flatten.map(&:to_i)
end

solutions = []

data[:time].count.times do |i|
  # Quadratic equation
  # a*x^2 + b*x + c = 0

  a = -1
  b = data[:time][i]
  c = -data[:distance][i]

  d = b ** 2 - 4 * a * c
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)

  # Counting all integers between two floats and adjusting in case x1 or x2 are integers
  adjustment = (x2.floor == x2 ? 1 : 0) + (x1.ceil == x1 ? 1 : 0)
  integer_count = (x2.floor - x1.ceil + 1) - adjustment

  solutions << {x1:, x2:, result: integer_count}
end

result = solutions.map { _1[:result] }.reduce :*
puts "Result: #{result}"
