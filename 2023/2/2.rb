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

game_results = games.map do |game_number, iterations|
  max_values = { red: 0, green: 0, blue: 0 }

  iterations.each do |iteration|
    max_values.keys.each do |color|
      max_values[color] = [max_values[color], iteration[color] || 0].max
    end
  end

  max_values.values.reduce :*
end

result = game_results.sum
puts "Result: #{result}"
