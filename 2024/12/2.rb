modifier = ".#{ARGV[0]}" if ARGV[0]

@input_data = []

File.open("./input#{modifier}.txt").each do |input_line|
  @input_data << input_line.strip.split('').map do
    { char: _1 }
  end
end

@width = @input_data.first.count
@height = @input_data.count

@plots = []

def same_char(y, x, current_char)
  return false if y < 0 || y >= @height
  return false if x < 0 || x >= @width

  @input_data[y][x][:char] == current_char
end

def plot_of_neighbour(y, x, current_char)
  return :outside if y < 0 || y >= @height
  return :outside if x < 0 || x >= @width

  return :outside if @input_data[y][x][:char] != current_char

  @input_data[y][x][:plot_index]
end

def check_neighbours(y, x)
  current_char = @input_data[y][x][:char]
  perimeter = 0
  current_plot = nil
  absorbed_points = []

  top_plot = plot_of_neighbour(y - 1, x, current_char)
  left_plot = plot_of_neighbour(y, x - 1, current_char)
  right_plot = plot_of_neighbour(y, x + 1, current_char)
  down_plot = plot_of_neighbour(y - 1, x, current_char)

  if left_plot == :outside
    perimeter += 1
  elsif !left_plot.nil?
    current_plot = left_plot
  end

  if top_plot == :outside
    perimeter += 1
  elsif !top_plot.nil?
    current_plot = top_plot
  end

  if right_plot == :outside
    perimeter += 1
  end

  if down_plot == :outside
    perimeter += 1
  end

  if current_plot.nil?
    @plots << {
      points: [[y, x]] + absorbed_points,
      char: current_char,
      perimeter: 0,
    }
    current_plot = @plots.count - 1

    @input_data[y][x][:plot_index] = current_plot
  else
    @plots[current_plot][:points] += [[y, x]] + absorbed_points

    @input_data[y][x][:plot_index] = current_plot

    if top_plot != :outside && top_plot && left_plot && left_plot != :outside && top_plot != left_plot
      @plots[top_plot][:points] += @plots[left_plot][:points]

      @plots[left_plot][:points].each do |point|
        j, i = point
        @input_data[j][i][:plot_index] = top_plot
      end

      @plots[left_plot][:points] = []
    end
  end
end

@height.times do |y|
  @width.times do |x|
    check_neighbours(y, x)
  end
end

def split_into_uninterrupted_chunks(array)
  array.sort.chunk_while { _1 + 1 == _2 }.to_a
end

def sum_for_side(side_hash)
  side_hash.values.sum { _1.count }
end

result = @plots.sum do |plot|
  horizontal_hash = {}
  vertical_hash = {}

  plot[:points].each do |point|
    y, x = point
    horizontal_hash[y] ||= []
    horizontal_hash[y] << x

    vertical_hash[x] ||= []
    vertical_hash[x] << y
  end

  top_hash = horizontal_hash.map do |y, xs|
    good_xs = xs.select { |x| !same_char(y - 1, x, @input_data[y][x][:char]) }

    [y, split_into_uninterrupted_chunks(good_xs)]
  end.to_h

  bottom_hash = horizontal_hash.map do |y, xs|
    good_xs = xs.select { |x| !same_char(y + 1, x, @input_data[y][x][:char]) }

    [y, split_into_uninterrupted_chunks(good_xs)]
  end.to_h

  left_hash = vertical_hash.map do |x, ys|
    good_ys = ys.select { |y| !same_char(y, x - 1, @input_data[y][x][:char]) }

    [x, split_into_uninterrupted_chunks(good_ys)]
  end.to_h

  right_hash = vertical_hash.map do |x, ys|
    good_ys = ys.select { |y| !same_char(y, x + 1, @input_data[y][x][:char]) }

    [x, split_into_uninterrupted_chunks(good_ys)]
  end.to_h

  (sum_for_side(top_hash) + sum_for_side(bottom_hash) + sum_for_side(left_hash) + sum_for_side(right_hash)) * plot[:points].count
end

puts "result = #{result}"

