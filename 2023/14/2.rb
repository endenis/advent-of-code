# Launch the file as:
# ruby 2.rb test
# or
# ruby 2.rb

test_suffix = %w[test].include?(ARGV[0]) ? ".#{ARGV[0]}" : nil

@table = []

ROUND_ROCK = 'O'.freeze
CUBE_ROCK = '#'.freeze
NOTHING = '.'.freeze

File.open("./input#{test_suffix}.txt").each do |raw_input_line|
  input_line = raw_input_line.strip

  @table << input_line.split('')
end

@width = @table[0].count
@height = @table.count

def fall_up(y, x)
  j = y

  while j > 0
    j -= 1

    break if j == 0 || @table[j - 1][x] != NOTHING
  end

  @table[y][x] = NOTHING
  @table[j][x] = ROUND_ROCK
end

def fall_left(y, x)
  i = x

  while i > 0
    i -= 1

    break if i == 0 || @table[y][i - 1] != NOTHING
  end

  @table[y][x] = NOTHING
  @table[y][i] = ROUND_ROCK
end

def fall_down(y, x)
  j = y

  while j < @height - 1
    j += 1

    break if j == @height - 1 || @table[j + 1][x] != NOTHING
  end

  @table[y][x] = NOTHING
  @table[j][x] = ROUND_ROCK
end

def fall_right(y, x)
  i = x

  while i < @width - 1
    i += 1

    break if i == @width - 1 || @table[y][i + 1] != NOTHING
  end

  @table[y][x] = NOTHING
  @table[y][i] = ROUND_ROCK
end


def tilt_north
  (1...@height).each do |y|
    (0...@width).each do |x|
      if @table[y][x] == ROUND_ROCK && @table[y - 1][x] == NOTHING
        fall_up(y, x)
      end
    end
  end
end

def tilt_left
  (0...@height).each do |y|
    (1...@width).each do |x|
      if @table[y][x] == ROUND_ROCK && @table[y][x - 1] == NOTHING
        fall_left(y, x)
      end
    end
  end
end

def tilt_south
  (0...@height).each do |offset_y|
    y = @height - 1 - offset_y

    (0...@width).each do |x|
      if @table[y][x] == ROUND_ROCK && @table[y + 1] && @table[y + 1][x] == NOTHING
        fall_down(y, x)
      end
    end
  end
end

def tilt_right
  (0...@height).each do |y|
    (0...@width).each do |offset_x|
      x = @width - 1 - offset_x

      if @table[y][x] == ROUND_ROCK && @table[y][x + 1] == NOTHING
        fall_right(y, x)
      end
    end
  end
end

def run_cycle
  tilt_north
  tilt_left
  tilt_south
  tilt_right
end

# Method used for debugging
def draw_table subject = false
  subject ||= @table

  (0...@height).each do |y|
    (0...@width).each do |x|
      print subject[y][x]
    end
    puts
  end
  puts
end

table_history = []

n = 0
history_index = 0

total_cycles = 1000000000

total_cycles.times do
  puts "#{n} / #{total_cycles}" if n % 100 == 0

  history_index = table_history.index(@table)
  if history_index
    puts "Found a loop! (#{n} => #{history_index})"
    break
  end

  table_history << @table.map { _1.dup }
  run_cycle

  n += 1
end

iteration_length = n - history_index
iterations_left_to_run = (total_cycles - history_index) % iteration_length

iterations_left_to_run.times { run_cycle }

result = (0...@height).sum do |y|
  @table[y].count(ROUND_ROCK) * (@height - y)
end

puts "Result = #{result}"
