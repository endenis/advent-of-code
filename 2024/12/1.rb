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
      perimeter:,
      char: current_char,
    }
    current_plot = @plots.count - 1

    @input_data[y][x][:plot_index] = current_plot
  else
    @plots[current_plot][:points] += [[y, x]] + absorbed_points
    @plots[current_plot][:perimeter] += perimeter

    @input_data[y][x][:plot_index] = current_plot

    if top_plot != :outside && top_plot && left_plot && left_plot != :outside && top_plot != left_plot
      @plots[top_plot][:perimeter] += @plots[left_plot][:perimeter]
      @plots[top_plot][:points] += @plots[left_plot][:points]

      @plots[left_plot][:points].each do |point|
        j, i = point
        @input_data[j][i][:plot_index] = top_plot
      end

      @plots[left_plot][:perimeter] = 0
      @plots[left_plot][:points] = []
    end
  end
end

@height.times do |y|
  @width.times do |x|
    check_neighbours(y, x)
  end
end

result = @plots.sum do
  _1[:points].count * _1[:perimeter]
end
puts "result = #{result}"
