@rules = {}
updates = []
parsing_rules = true

File.open('./input.txt').each do |input|
  line = input.strip
  if line.empty?
    parsing_rules = false
    next
  end

  if parsing_rules
    left, right = line.split('|').map(&:to_i)

    @rules[left] ||= {}
    @rules[left][:right] ||= []
    @rules[left][:right] << right

    @rules[right] ||= {}
    @rules[right][:left] ||= []
    @rules[right][:left] << left
  else
    updates << line.split(',').map(&:to_i)
  end
end

def row_correct?(row)
  passed_numbers = []

  row.each do |number|
    expected_on_the_right = @rules.dig(number, :right) || []
    return false unless (expected_on_the_right & passed_numbers).empty?

    passed_numbers << number
  end

  true
end

correct_updates = updates.select { row_correct?(_1) }
result = correct_updates.sum { _1[_1.count / 2] }

puts "result = #{result}"
