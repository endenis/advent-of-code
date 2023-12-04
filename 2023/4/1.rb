cards = {}

line_regexp = /^Card\s+(\d+)\:\s+(.+)\|\s+(.+)/

File.open('./input.txt').each do |input|
  input_line = input.strip
  scan_result = input_line.scan(line_regexp).first

  card_number = scan_result[0].to_i
  left_numbers = scan_result[1].split(' ').map(&:to_i)
  right_numbers = scan_result[2].split(' ').map(&:to_i)

  intersection = left_numbers.intersection right_numbers
  score = intersection.empty? ? 0 : 2 ** (intersection.count - 1)

  cards[card_number] = {score:, intersection:}
end

result = cards.values.sum { _1[:score] }
puts "Result: #{result}"
