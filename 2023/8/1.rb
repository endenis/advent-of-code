instructions = nil
nodes = {}

node_regexp = /(\S+) = \((\S+), (\S+)\)/

File.open('./input.txt').each do |raw_input_line|
  input_line = raw_input_line.strip

  if input_line =~ /^[RL]+$/
    instructions = input_line.split('').map(&:to_sym)
  else
    match = input_line.match node_regexp
    next unless match

    node_name, left_node, right_node = match.to_a.drop(1)
    nodes[node_name] = {L: left_node, R: right_node, node_name:}
  end
end

current_node = nodes['AAA']
i = 0
iterations_limit = 1_000_000
instructions_count = instructions.count

while current_node[:node_name] != 'ZZZ' && i < iterations_limit
  instruction = instructions[i % instructions_count]

  node_name = current_node[instruction]
  current_node = nodes[node_name]
  i += 1
end

result = i + 1
puts "Result: #{i}"
