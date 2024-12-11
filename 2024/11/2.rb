modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip

initial_stones = input.split(' ').map(&:to_i)

stones = {}

initial_stones.each do |stone|
  stones[stone] ||= 0
  stones[stone] += 1
end

puts "Initial arrangement:"
puts stones.inspect

def add_stone(stones, stone, times)
  stones[stone] ||= 0
  stones[stone] += times
end

def remove_stone(stones, stone, times)
  stones[stone] -= times
end

75.times do |n|
  keys = stones.keys.select do |stone|
    stones[stone] && stones[stone] > 0
  end

  extra_stones = {}

  keys.each do |stone|
    number = stones[stone]

    if stone == 0
      remove_stone(stones, 0, number)
      add_stone(extra_stones, 1, number)
    else
      stone_string = stone.to_s
      length = stone_string.length
      remove_stone(stones, stone, number)

      if length.even?
        half_length = length / 2
        add_stone(extra_stones, stone_string[0, half_length].to_i, number)
        add_stone(extra_stones, stone_string[half_length, length].to_i, number)
      else
        add_stone(extra_stones, stone * 2024, number)
      end
    end
  end

  extra_stones.each do |k, v|
    stones[k] ||= 0
    stones[k] += v
  end
end

result = stones.values.compact.sum
puts "result = #{result}"
