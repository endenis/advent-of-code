cards = {}

line_regexp = /^Card\s+(\d+)\:\s+(.+)\|\s+(.+)/

File.open('./input.txt').each do |input|
  input_line = input.strip
  scan_result = input_line.scan(line_regexp).first

  card_number = scan_result[0].to_i
  left_numbers = scan_result[1].split(' ').map(&:to_i)
  right_numbers = scan_result[2].split(' ').map(&:to_i)

  intersection = left_numbers.intersection right_numbers

  cards[card_number] = {intersection:, number_of_copies: 1}
end

cards.each do |card_number, card|
  number_of_winning_numbers = card[:intersection].count

  number_of_winning_numbers.times do |i|
    cards[card_number + i + 1][:number_of_copies] += card[:number_of_copies]
  end
end

result = cards.values.sum { _1[:number_of_copies] }
puts "Result: #{result}"
