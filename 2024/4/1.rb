@data = []

File.open('./input.txt').each do |input|
  @data << input.strip.split('')
end

@width = @data.first.count
@height = @data.count

result = 0

def get_next_char(current_char)
  {
    'X' => 'M',
    'M' => 'A',
    'A' => 'S',
    'S' => :end,
  }[current_char]
end

@all_directions = %i[ne n nw e w se s sw]

def neighbouring_indexes(y, x)
  [
    [:ne, [y - 1, x - 1]],
    [:n, [y - 1, x]],
    [:nw, [y - 1, x + 1]],
    [:e, [y, x - 1]],
    [:w, [y, x + 1]],
    [:se, [y + 1, x - 1]],
    [:s, [y + 1, x]],
    [:sw, [y + 1, x + 1]],
  ].select do |_direction, coordinates|
    some_y, some_x = coordinates
    some_x >= 0 && some_x < @width && some_y >= 0 && some_y < @height
  end.to_h
end

def find_at(y, x, direction)
  next_char = get_next_char(@data[y][x])
  return 1 if next_char == :end

  coordinates = neighbouring_indexes(y, x)[direction]
  return 0 unless coordinates
  j, i = coordinates

  return 0 unless @data[j][i] == next_char
  
  find_at(j, i, direction)
end

@height.times do |y|
  @width.times do |x|
    next if @data[y][x] != 'X'

    result += @all_directions.sum do |direction|
      find_at(y, x, direction) || 0
    end
  end
end

puts "result = #{result}"
