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

incorrect_updates = updates.select { !row_correct?(_1) }

def fix_row(row)
  passed_numbers = []
  row.each_with_index do |number, i|
    expected_on_the_right = @rules.dig(number, :right) || []

    passed_numbers.each do |passed_pair|
      passed_number, passed_index = passed_pair

      if expected_on_the_right.include?(passed_number)
        row[passed_index] = number
        row[i] = passed_number

        return fix_row(row)
      end
    end

    passed_numbers << [number, i]
  end

  row
end

result = incorrect_updates.sum do
  array = fix_row(_1)
  array[array.count / 2]
end

puts "result = #{result}"
