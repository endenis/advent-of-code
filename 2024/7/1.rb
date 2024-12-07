@equations = []

File.open('./input.txt').each_with_index do |input, i|
  left_part, right_part = input.strip.split(':')

  @equations << {result: left_part.to_i, numbers: right_part.split(' ').map(&:to_i)}
end

def compute_line(equation, operator_array)
  sum = 0
  all_operators_array = [:+] + operator_array
  i = 0

  equation[:numbers].each do |number|
    sum = [sum, number].reduce all_operators_array[i]
    return false if sum > equation[:result]

    i += 1
  end

  equation[:result] == sum
end

operators = [:+, :*]

@equations.each do |equation|
  number_of_operators = equation[:numbers].count - 1
  permutation = operators.repeated_permutation(number_of_operators)

  permutation.each do |operator_array|
    if compute_line(equation, operator_array)
      equation[:correct] = true
      break
    end
  end
end

result = @equations.sum { _1[:correct] ? _1[:result] : 0 }
puts "result = #{result}"
