# Launch the file as:
# ruby 2.rb test
# or
# ruby 2.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

@data = []

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip
  pattern, numbers_part = input_line.split ' '

  # "Unfold" the input data as described for the part 2
  pattern = ([pattern] * 5).join('?')
  numbers_part = ([numbers_part] * 5).join(',')

  numbers = numbers_part.split(',').map(&:to_i)

  @data << { pattern:, numbers:, cache: {} }
end

def compute_for chars, numbers, j
  @data[j][:cache][[chars, numbers]] ||= process_first_char chars, numbers, j
end

def replace_first chars, new_first
  chars[1..].unshift new_first
end

def should_continue? chars, length_ahead, first_number
  first_number != nil && length_ahead >= first_number && chars[first_number] != '#'
end

def compute_length_ahead chars
  chars.each_with_index do |char, index|
    return index if char != '#' && char != '?'
  end

  chars.count
end

def process_first_char chars, numbers, j
  return 1 if chars.empty? && numbers.empty?

  first_char = chars.first
  first_number = numbers.first

  case first_char
  when '?'
    compute_for(replace_first(chars, '.'), numbers, j) + compute_for(replace_first(chars, '#'), numbers, j)
  when '.'
    compute_for chars[1..], numbers, j
  when '#'
    length_ahead = compute_length_ahead chars

    if should_continue? chars, length_ahead, first_number
      next_chars = chars[(first_number + 1)..] || [] # chars[n..] can return nil if out of bounds
      compute_for next_chars, numbers[1..], j
    else
      0
    end
  when nil
    0
  end
end

result_count = 0
total_count = @data.count

@data.each_with_index do |entry, j|
  entry_result = compute_for(entry[:pattern].chars, entry[:numbers], j)

  @data[j][:cache] = nil # Clean the cache from memory

  result_count += entry_result
end

puts "Result: #{result_count}"
