# Launch the file as:
# ruby 2.rb test
# or
# ruby 2.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

boxes = 256.times.map do |n|
  {
    n:,
    lenses: {},
  }
end

input_data = []

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip
  input_data += input_line.split(',')
end

def holiday_hash string
  current_value = 0

  string.split('').each do
    current_value += _1.ord
    current_value *= 17
    current_value = current_value % 256
  end

  current_value
end

input_data.each do |entry|
  if entry.chars.last == '-'
    label = entry[0...-1]
    box_n = holiday_hash label
    boxes[box_n][:lenses].delete label
  else
    label, focal_length_string = entry.split('=')
    box_n = holiday_hash label
    boxes[box_n][:lenses][label] = focal_length_string.to_i
  end
end

result = boxes.sum do |box|
  box[:lenses].values.map.with_index do |focal_length, index|
    (box[:n] + 1) * focal_length * (index + 1)
  end.sum
end

puts "Result: #{result}"
