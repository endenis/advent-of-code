data = {}
seeds = []

keys = %w[
  seed-to-soil
  soil-to-fertilizer
  fertilizer-to-water
  water-to-light
  light-to-temperature
  temperature-to-humidity
  humidity-to-location
]
key_regexp = Regexp.union keys
number_line_regexp = /(\d+)/
seed_line_prefix = 'seeds: '

current_section = nil

File.open('./input.txt').each do |input|
  input_line = input.strip
  key_match = input_line.match key_regexp
  number_line_matches = input_line.scan number_line_regexp

  if key_match
    current_section = key_match.to_s
    data[current_section] = []
  elsif input_line.start_with? seed_line_prefix
    seeds = input_line.scan(number_line_regexp).map { _1.first.to_i }
  elsif number_line_matches.any?
    matching_numbers = number_line_matches.map { _1.first.to_i }
    destination_start, source_start, range_length = matching_numbers
    data[current_section] << {
      destination_start:,
      source_start:,
      range_length:,
    }
  end
end

def map_number(map_data, input_number)
  map_data.each do |map_entry|
    right_boundary = map_entry[:source_start] + map_entry[:range_length]
    range = map_entry[:source_start]...right_boundary

    if range.include? input_number
      mapping = input_number - map_entry[:source_start] + map_entry[:destination_start]
      return mapping
    end
  end

  input_number
end

seed_results = seeds.map do |seed_number|
  seed_result = seed_number

  keys.each do |key|
    seed_result = map_number data[key], seed_result
  end

  seed_result
end

result = seed_results.min
puts "Result: #{result}"
