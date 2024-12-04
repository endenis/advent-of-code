@data = []

File.open('./input.txt').each do |input|
  @data << input.strip.split('')
end

@width = @data.first.count
@height = @data.count

result = 0

@shapes = [
  [
    ['M', '.', 'M'],
    ['.', 'A', '.'],
    ['S', '.', 'S'],
  ],
  [
    ['M', '.', 'S'],
    ['.', 'A', '.'],
    ['M', '.', 'S'],
  ],
  [
    ['S', '.', 'S'],
    ['.', 'A', '.'],
    ['M', '.', 'M'],
  ],
  [
    ['S', '.', 'M'],
    ['.', 'A', '.'],
    ['S', '.', 'M'],
  ],
];

def cursor_from(y, x)
  [
    [@data[y][x], @data[y][x + 1], @data[y][x + 2]],
    [@data[y + 1][x], @data[y + 1][x + 1], @data[y + 1][x + 2]],
    [@data[y + 2][x], @data[y + 2][x + 1], @data[y + 2][x + 2]],
  ]
end

def good_fit?(matrix, shape)
  3.times do |j|
    3.times do |i|
      next if shape[j][i] == '.'

      return false if shape[j][i] != matrix[j][i]
    end
  end

  true
end

@height.times do |y|
  break if y > @height - 3

  @width.times do |x|
    break if x > @width - 3

    matrix = cursor_from(y, x)

    fits_any_shape = @shapes.any? { |shape| good_fit?(matrix, shape) }
    result += 1 if fits_any_shape
  end
end

puts "result = #{result}"
