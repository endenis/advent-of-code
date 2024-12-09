modifier = ".#{ARGV[0]}" if ARGV[0]

input = File.read("./input#{modifier}.txt").strip

data = []
id = 0

input.length.times do |n|
  i = input.chars[n].to_i
  puts "n: #{n}" if n % 100 == 0
  next if i == 0

  if n.even?
    data << {value: id, length: i}
    id += 1
  else
    data << {value: '.', length: i}
  end
end

puts "processing..."

j = data.count - 1

length = data.count

def merge_empty_neighbours data, j
  if data[j + 1] && data[j + 1][:value] == '.' && data[j][:value] == '.'
    data[j][:length] += data[j + 1][:length]
    data.delete_at(j + 1)
  end

  if data[j - 1] && data[j - 1][:value] == '.' && data[j][:value] == '.'
    data[j - 1][:length] += data[j][:length]
    data.delete_at(j)
  end
end

while j >= 0
  puts "j: #{j} / #{length}" if j % 100 == 0

  if data[j][:value] == '.'
    j -= 1
    next
  end

  i = 0
  while i < j
    if data[i][:value] == '.'
      if data[i][:length] > data[j][:length]
        extra_length = data[i][:length] - data[j][:length]

        data[i][:length] = data[j][:length]
        data[i][:value] = data[j][:value]
        data[j][:value] = '.'

        merge_empty_neighbours(data, j - 1)

        data.insert(i + 1, {value: '.', length: extra_length})
        j += 1

        break
      elsif data[i][:length] == data[j][:length]
        data[i][:value], data[j][:value] = data[j][:value], data[i][:value]

        merge_empty_neighbours(data, j)

        break
      end
    end
    i += 1
  end

  j -= 1
end

rendered_data = []
data.each do |entry|
  rendered_data += [entry[:value]] * entry[:length]
end

puts rendered_data.join

result = rendered_data.map.with_index do |value, i|
  value == '.' ? 0 : value * i
end.sum

puts "result = #{result}"
