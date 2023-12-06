data = {}

File.open('./input.txt').each do |input|
  input_line = input.strip
  current_key = nil

  if input_line.start_with? 'Time'
    current_key = :time
  elsif input_line.start_with? 'Distance'
    current_key = :distance
  end

  data[current_key] = input_line.scan(/(\d+)/).flatten.join.to_i
end

# Quadratic equation
# a*x^2 + b*x + c = 0

a = -1
b = data[:time]
c = -data[:distance]

d = b ** 2 - 4 * a * c
x1 = (-b + Math.sqrt(d)) / (2 * a)
x2 = (-b - Math.sqrt(d)) / (2 * a)

# Counting all integers between two floats and adjusting in case x1 or x2 are integers
adjustment = (x2.floor == x2 ? 1 : 0) + (x1.ceil == x1 ? 1 : 0)
integer_count = (x2.floor - x1.ceil + 1) - adjustment

puts "Result: #{integer_count}"
