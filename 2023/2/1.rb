games = {}

game_regexp = /^Game (\d+)\: (.*)/
iteration_regexp = /(\d+) (red|green|blue|)/

File.open('./input.txt').each do |input|
  input_line = input.strip

  match = input.match game_regexp
  game_number = match[1].to_i
  iterations_line = match[2]

  games[game_number] = []

  iterations_line.split(';').map(&:strip).each do |iteration_string|
    regexp_scan = iteration_string.scan iteration_regexp
    iteration_hash = regexp_scan.map { |key, value| [value.to_sym, key.to_i] }.to_h

    games[game_number] << iteration_hash
  end
end

@max_values = { red: 12, green: 13, blue: 14 }

def okay_number_of_cubes?(iteration, color)
  (iteration[color] || 0) <= @max_values[color]
end

game_results = games.map do |game_number, iterations|
  is_game_okay = true

  iterations.each do |iteration|
    is_game_okay = okay_number_of_cubes?(iteration, :red) && 
      okay_number_of_cubes?(iteration, :green) &&
      okay_number_of_cubes?(iteration, :blue)

    break unless is_game_okay
  end

  game_number if is_game_okay
end

result = game_results.compact.sum
puts "Result: #{result}"
