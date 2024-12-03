input = File.read('./input.txt').strip

input.gsub! "\n", ' '

cleaning_regex = /don\'t\(\).*?do\(\)/
input.gsub! cleaning_regex, ''

end_regex = /don\'t.+/
input.gsub! end_regex, ''

match_regex = /mul\((\d+),(\d+)\)/
matches = input.scan match_regex

result = matches.sum do |match|
  left, right = match
  left.to_i * right.to_i
end

puts "result = #{result}"
