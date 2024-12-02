lines = []

File.open('./input.txt').each do |input|
  lines << input.strip.split(' ').map(&:to_i)
end

result = 0

class Array
  def reject_at_index(index)
    reject.with_index { |_,i| i == index }
  end
end

def safe_line?(line, first_try)
  direction = nil
  line_result = true

  # current_i = current index
  # current_j = current index - 1
  # current_k = current index - 2
  current_i, current_j, current_k = nil, nil, nil

  line.each_with_index do |number, i|
    next if i == 0

    current_i = i
    current_j = i - 1
    current_k = i - 2

    difference = line[current_i] - line[current_j]

    if direction.nil? && difference != 0
      direction = (difference > 0) ? :increasing : :decreasing
    end

    if difference == 0 ||
      difference.abs > 3 ||
      (direction != nil && difference < 0 && direction == :increasing) ||
      (direction != nil && difference > 0 && direction == :decreasing)
      line_result = false

      break
    end
  end

  return true if line_result
  return false unless first_try

  safe_line?(line.reject_at_index(current_i), false) ||
    safe_line?(line.reject_at_index(current_j), false) ||
    (current_k >= 0 && safe_line?(line.reject_at_index(current_k), false))
end

lines.each do |line|
  is_line_safe = safe_line?(line, true)
  result += 1 if is_line_safe
end

puts "result = #{result}"
