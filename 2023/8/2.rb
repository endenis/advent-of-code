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

current_nodes = nodes.values.select { _1[:node_name].end_with? 'A' }

puts "Starting nodes: #{current_nodes.map { _1[:node_name] }.inspect}"

node_results = {}

current_nodes.each do |node|
  puts "starting node #{node[:node_name]}"
  current_node = node
  i = 0
  iterations_limit = 1_000_000
  instructions_count = instructions.count

  # I recorded history, solution position and the length of the loop in order to explore the data.
  # History is not actually used in computation of the result.
  history = []
  solution_i = nil
  loop_offset = nil

  while i < iterations_limit
    if solution_i
      # This code looks at previously visited nodes in order to find a loop
      history_index = history.index(current_node[:node_name])

      if history_index
        puts "loop node: #{current_node.inspect}"
        loop_offset = i - solution_i

        break
      end
    end

    history << current_node[:node_name]

    instruction = instructions[i % instructions_count]

    node_name = current_node[instruction]
    current_node = nodes[node_name]
    i += 1

    if current_node[:node_name].end_with?('Z')
      puts "end node: #{current_node.inspect}"
      solution_i = i
    end
  end

  node_results[current_node[:node_name]] = {solution_i:, loop_offset:, history_index:}
end

pp node_results

# After observing the data I found that after each ..Z node we get a node that was already present before.
# Therefore we are in a loop. I decided to try to compute LCM on the solutions and... it worked.
# I don't think this approach would work with generic input though.

result = node_results.map { _2[:solution_i] }.reduce &:lcm
puts "Result: #{result}"
