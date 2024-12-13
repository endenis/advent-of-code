modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip
regex = /Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/m

data = input.scan(regex)

result = 0

data.each_with_index do |entry, i|
  a_x, a_y, b_x, b_y, prize_x, prize_y = entry.map(&:to_f)

  # a_x * d + b_x * g = prize_x
  # a_y * d + b_y * g = prize_y

  # Represent d using g:
  # d = (prize_x - b_x * g) / a_x

  # Then:
  # a_y * (prize_x - b_x * g) + a_x * b_y * g = prize_y * a_x
  # a_y * prize_x - a_y * b_x * g + a_x * b_y * g = prize_y * a_x
  # (a_x * b_y - a_y * b_x) * g = prize_y * a_x - a_y * prize_x

  # Formulat for g:
  # g = (prize_y * a_x - a_y * prize_x) / (a_x * b_y - a_y * b_x)

  g = (prize_y * a_x - a_y * prize_x) / (a_x * b_y - a_y * b_x)
  d = (prize_x - b_x * g) / a_x

  if g < 100 && d < 100 && g >= 0 && d >= 0 && g % 1 == 0 && d % 1 == 0
    puts "for i #{i}: d = #{d}, g = #{g}"

    result += g + d * 3
  end
end

puts "result = #{result.to_i}"
