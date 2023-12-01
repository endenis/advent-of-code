lines = []

File.open('./input.txt').each do |input|
  input_line = input.strip
  lines << input_line unless input_line.empty?
end

digit_matcher = ->(char) { char.match? /\d/ }

line_numbers = lines.map do |line|
  chars = line.split('')

  left_digit_index = chars.index &digit_matcher
  right_digit_index = chars.rindex &digit_matcher

  left_digit = chars[left_digit_index].to_i
  right_digit = chars[right_digit_index].to_i

  left_digit * 10 + right_digit
end

result = line_numbers.sum
puts "Result #{result}"
