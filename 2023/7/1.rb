data = []

card_values = {
  'A' => 13,
  'K' => 12,
  'Q' => 11,
  'J' => 10,
  'T' => 9,
  '9' => 8,
  '8' => 7,
  '7' => 6,
  '6' => 5,
  '5' => 4,
  '4' => 3,
  '3' => 2,
  '2' => 1,
}

hand_type_priorities = {
  [5] => 7,
  [4, 1] => 6,
  [3, 2] => 5,
  [3, 1, 1] => 4,
  [2, 2, 1] => 3,
  [2, 1, 1, 1] => 2,
  [1, 1, 1, 1, 1] => 1,
}

File.open('./input.txt').each do |raw_input_line|
  input_line = raw_input_line.strip
  hand_string, bid_string = input_line.split(' ')

  bid = bid_string.to_i
  hand_chars = hand_string.split('')

  hand_values = hand_chars.map { card_values[_1] }
  hand_type = hand_chars.tally.values.sort.reverse
  hand_type_priority = hand_type_priorities[hand_type]

  data << { bid:, hand_chars:, hand_values:, hand_type_priority: }
end

def hand_sorting_score(hand)
  hand.slice(:hand_type_priority, :hand_values).values
end

sorted_cards = data.sort do |hand_a, hand_b|
  hand_sorting_score(hand_a) <=> hand_sorting_score(hand_b)
end

i = 0
result = sorted_cards.inject(0) do |sum, hand|
  i += 1
  sum + (i * hand[:bid])
end

puts "Result: #{result}"
