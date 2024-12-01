left_array = []
right_array = []

File.open('./input.txt').each do |input|
  line_numbers = input.strip.split('   ')
  left_array << line_numbers.first.to_i
  right_array << line_numbers.last.to_i
end

times_number_appears = right_array.tally

result = left_array.sum do |number|
  number * (times_number_appears[number] || 0)
end

puts "result = #{result}"
