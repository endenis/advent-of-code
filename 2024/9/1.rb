modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip

data = []
id = 0
offset = 0

input.length.times do |n|
  i = input.chars[n].to_i
  puts "n: #{n}" if n % 100 == 0

  if n.even?
    data += [id] * i
    id += 1
  else
    data += ['.'] * i
  end
  offset += i
end

j = data.count - 1

data.count.times do |i|
  puts "i: #{i}" if i % 100 == 0

  break if i >= j - 1
  next if data[i] != '.'

  while data[j] == '.'
    j -= 1
  end

  if data[j] && data[j] != '.'
    data[i] = data[j]
    data[j] = '.'
  end
end

result = data.map.with_index do |value, i|
  value == '.' ? 0 : value * i
end.sum

puts "result = #{result}"
