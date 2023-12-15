# Launch the file as:
# ruby 1.rb test
# or
# ruby 1.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

table = []

ROUND_ROCK = 'O'.freeze
CUBE_ROCK = '#'.freeze
NOTHING = '.'.freeze

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  table << input_line.split('')
end

height = table.count

def fall_down(table, y, x)
  j = y

  while j > 0
    j -= 1

    break if j == 0 || table[j - 1][x] != NOTHING
  end

  table[y][x] = NOTHING
  table[j][x] = ROUND_ROCK
end

(1...height).each do |y|
  (0...table[y].count).each do |x|
    if table[y][x] == ROUND_ROCK && table[y - 1][x] == NOTHING
      fall_down(table, y, x)
    end
  end
end

result = (0...height).sum do |y|
  table[y].count(ROUND_ROCK) * (height - y)
end

puts "Result = #{result}"
