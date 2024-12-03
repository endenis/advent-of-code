input = File.read('./input.txt').strip

regex = /mul\((\d+),(\d+)\)/
matches = input.scan regex

result = matches.sum do |match|
  left, right = match
  left.to_i * right.to_i
end

puts "result = #{result}"
