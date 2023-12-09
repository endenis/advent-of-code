# Launch the file as:
# ruby 2.rb test
# or
# ruby 2.rb

lines = []
test_suffix = ARGV[0] == 'test' ? '.test' : nil

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  lines << input_line.split(' ').map(&:to_i)
end

def compute_next_sequence(sequence)
  [].tap do |next_sequence|
    sequence.count.times do |i|
      next if i == 0

      next_sequence << sequence[i] - sequence[i - 1]
    end
  end
end

sum = 0

lines.each do |sequence|
  sequences = [sequence]

  while !sequences.last.all?(0)
    next_sequence = compute_next_sequence(sequences.last)
    sequences << next_sequence
  end

  sequences.last << 0
  sequences_count = sequences.count

  sequences_count.times do |j|
    next if j == 0

    i = sequences_count - 1 - j
    first_element = sequences[i].first - sequences[i + 1].first
    sequences[i].unshift first_element
  end

  sum += sequences.first.first
end

puts "Result: #{sum}"
