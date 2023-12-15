# Launch the file as:
# ruby 1.rb test
# or
# ruby 1.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

data = []

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip
  data += input_line.split(',')
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

result = data.sum { holiday_hash _1 }

puts "Result: #{result}"
