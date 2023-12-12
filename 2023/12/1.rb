# Launch the file as:
# ruby 1.rb test
# or
# ruby 1.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

data = []

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  pattern, numbers_part = input_line.split ' '

  numbers = numbers_part.split(',').map(&:to_i)
  regex_parts = numbers.map do
    "\#{#{_1}}"
  end
  joined_regex_parts = regex_parts.join('(\.)+')
  regex = /^(\.)*#{joined_regex_parts}(\.)*$/

  need_to_add_count = numbers.sum - pattern.count('#')
  data << { pattern:, regex:, need_to_add_count:  }
end

result_count = 0

total_count = data.count

data.each_with_index do |entry, j|
  puts "Processing #{j} / #{total_count}"

  pattern = entry[:pattern]
  regex = entry[:regex]

  question_positions = pattern.length.times.select { pattern[_1] == '?' }

  combinations = question_positions.combination(entry[:need_to_add_count]).to_a

  pattern_chars = pattern.chars
  combinations.each do |combination|
    new_chars = pattern_chars.map.with_index do |char, index|
      if char == '?'
        combination.include?(index) ? '#' : '.'
      else
        char
      end
    end
    new_string = new_chars.join

    result_count += 1 if new_string.match?(regex)
  end
end
puts "Result: #{result_count}"



