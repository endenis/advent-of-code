data = {}
seed_ranges = []

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
    seed_input = input_line.scan(number_line_regexp).map { _1.first.to_i }
    seed_ranges = seed_input.each_slice(2).to_a.sort_by(&:first).map { _1...(_1 + _2) } 
  elsif number_line_matches.any?
    matching_numbers = number_line_matches.map { _1.first.to_i }
    destination_start, source_start, range_length = matching_numbers
    data[current_section] << {
      left: source_start,
      right: source_start + range_length,
      mapping_offset: destination_start - source_start,
    }
  end
end

# I assume that seed ranges don't overlap
seed_data = seed_ranges.map do |range|
  [
    # This is the data structure that I use for all ranges
    {
      left: range.first,
      right: range.last, # not included inside the range
      mapping_offset: 0,
    },
  ]
end

# Super ugly method that computes new ranges after comparing two ranges
# This method takes care of all possible intersections between two ranges.
# For example, when intersecting 10...100 with offset A and 25...30 with offset B
# the result would be: 10...25 with offset A, 25...30 with offset B, 30...100 with offset A.
def intersect_ranges range_one, range_two
  a, b = range_one[:left], range_one[:right]
  c, d = range_two[:left], range_two[:right]

  if b <= c || a >= d
    [
      range_one.dup,
    ]
  elsif a >= c && b <= d
    [
      {
        left: a,
        right: b,
        mapping_offset: range_two[:mapping_offset],
      }
    ]
  elsif a <= c && b >= d
    [
      {
        left: a,
        right: c,
        mapping_offset: range_one[:mapping_offset],
      },
      range_two.dup,
      {
        left: d,
        right: b,
        mapping_offset: range_one[:mapping_offset],
      }
    ]
  elsif a > c && b > d
    [
      {
        left: a,
        right: d,
        mapping_offset: range_two[:mapping_offset],
      },
      {
        left: d,
        right: b,
        mapping_offset: range_one[:mapping_offset],
      }
    ]
  elsif a < c && b < d
    [
      {
        left: a,
        right: c,
        mapping_offset: range_one[:mapping_offset],
      },
      {
        left: c,
        right: b,
        mapping_offset: range_two[:mapping_offset],
      }
    ]
  else
    raise "Uncovered case! a = #{a}, b = #{b}, c = #{c}, d = #{d}"
  end
end

result_data = seed_data.map do |seed_entry|
  seed_ranges = seed_entry

  keys.each do |key|
    data[key].each do |data_entry|
      seed_ranges = seed_ranges.flat_map do |seed_range|
        intersect_ranges(seed_range, data_entry).reject { _1[:left] == _1[:right] }
      end
    end

    seed_ranges.each do
      _1[:left] += _1[:mapping_offset]
      _1[:right] += _1[:mapping_offset]
      _1[:mapping_offset] = 0
    end
  end

  seed_ranges.flatten
end

result = result_data.flatten.map { _1[:left] }.min
puts "Result: #{result}"
