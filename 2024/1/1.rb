left_array = []
right_array = []

File.open('./input.txt').each do |input|
  line_numbers = input.strip.split('   ')
  left_array << line_numbers.first.to_i
  right_array << line_numbers.last.to_i
end

sorted_left_array = left_array.sort
sorted_right_array = right_array.sort

result = 0

sorted_left_array.count.times do |i|
  result += (sorted_left_array[i] - sorted_right_array[i]).abs
end

puts "result = #{result}"
