lines = []

File.open('./input.txt').each do |input|
  input_line = input.strip
  lines << input_line unless input_line.empty?
end

text_digits = {
  # This is a hack to finish the level fast. It would not work with longer combinations like "oneightwo".
  # I made a more generic solution afterwards (the 2a.rb file).
  'zerone' => 01,
  'oneight' => 18,
  'twone' => 21,
  'threeight' => 38,
  'fiveight' => 58,
  'sevenine' => 79,
  'eightwo' => 82,
  'eighthree' => 83,
  'nineight' => 98,

  'zero' => 0,
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9,
}

regexp = Regexp.union text_digits.keys

lines.each do |line|
  line.gsub! regexp, text_digits
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
