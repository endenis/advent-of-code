modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip

stones = input.split(' ').map(&:to_i)

puts "Initial arrangement:"
puts stones.inspect

25.times do |n|
  puts "Computed #{n + 1} blinks"

  stones = stones.flat_map do |stone|
    if stone == 0
      1
    else
      stone_string = stone.to_s
      length = stone_string.length
      if length.even?
        half_length = length / 2
        [stone_string[0, half_length].to_i, stone_string[half_length, length].to_i]
      else
        stone * 2024
      end
    end 
  end
end

puts "result = #{stones.count}"
