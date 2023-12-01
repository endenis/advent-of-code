lines = []

File.open('./input.txt').each do |input|
  input_line = input.strip
  lines << input_line unless input_line.empty?
end

digit_matcher = ->(char) { char.match? /\d/ }

@text_digits = {
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
@regexp = Regexp.union @text_digits.keys

def word_is_more_important?(digit_index, word_index, direction)
  return true if digit_index.nil?
  return false if word_index.nil?

  if direction == :left
    word_index < digit_index
  else
    word_index > digit_index
  end
end

def choose_between_digit_match_and_word_match line, digit_index, word_index, direction
  if word_is_more_important?(digit_index, word_index, direction)
    word = line.match(@regexp, word_index).to_s
    @text_digits[word]
  else
    line[digit_index].to_i
  end
end

line_numbers = lines.map do |line|
  chars = line.split('')

  left_digit_index = chars.index &digit_matcher
  right_digit_index = chars.rindex &digit_matcher

  left_word_index = line.index(@regexp)
  right_word_index = line.rindex(@regexp)

  left_digit = choose_between_digit_match_and_word_match line, left_digit_index, left_word_index, :left
  right_digit = choose_between_digit_match_and_word_match line, right_digit_index, right_word_index, :right

  left_digit * 10 + right_digit
end

result = line_numbers.sum
puts "Result #{result}"
