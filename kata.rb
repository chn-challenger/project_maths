# map = [[true, false],
#     [true, true]];
#
# solve(map, {'x'=>0,'y'=>0}, {'x'=>1,'y'=>1})
# Should return ['right', 'down']

map = [
  [true,  false,  true,   false,  true,   false,  true],
  [true,  false,  true,   true,  true,   false,  true],
  [true,  true,   true,   true,   true,   true,   true],
  [true,  false,  true,   false,  true,   false,  true],
  [true,  false,  true,   false,  true,   false,  true]
]

starting_position = [2,3]
target = [0,2]

def scan(position,path,map)
  possible_moves = []
  x_max, y_max = map.length - 1, map.first.length - 1
  if 0 <= position[0]-1 && map[position[0]-1][position[1]]
    possible_move = position.dup
    possible_move[0] = possible_move[0] - 1
    possible_moves << possible_move
  end
  if position[1]+1 <= y_max && map[position[0]][position[1]+1]
    possible_move = position.dup
    possible_move[1] = possible_move[1] + 1
    possible_moves << possible_move
  end
  if position[0]+1 <= x_max && map[position[0]+1][position[1]]
    possible_move = position.dup
    possible_move[0] = possible_move[0] + 1
    possible_moves << possible_move
  end
  if 0 <= position[1]-1 && map[position[0]][position[1]-1]
    possible_move = position.dup
    possible_move[1] = possible_move[1] - 1
    possible_moves << possible_move
  end
  return possible_moves - path
end

def adjacent?(pos_1,pos_2)
  (pos_1[0] - pos_2[0]).abs + (pos_1[1] - pos_2[1]).abs == 1
end


# p adjacent?([2,2],[1,2])

def move_a_step(current_path,other_choices,map,target)
  possible_moves = scan(current_path.last,current_path,map)
  puts 'possible moves'
  p possible_moves
  if possible_moves != []
    next_move = possible_moves.delete_at(0)
    if possible_moves != []
      other_choices[current_path.last] = possible_moves
    end
    current_path << next_move
  else
    last_junction = other_choices.keys.last.dup
    junction_index = current_path.index(last_junction)
    current_path.delete_if do |ele|
      current_path.index(ele) > junction_index
    end
    next_move = other_choices[current_path.last].delete_at(0)
    if other_choices[current_path.last] == []
      other_choices.delete(current_path.last)
    end
    current_path << next_move
  end

  if current_path.last == target
    return current_path
  else
    move_a_step(current_path,other_choices,map,target)
  end

end

map = [
  [false, false,  true,   false,  true,   false,  true],
  [false, false,  true,   false,  true,   false,  true],
  [true,  true,   true,   true,   true,   true,   true],
  [true,  false,  true,   false,  true,   false,  true],
  [true,  false,  true,   false,  true,   false,  true]
]

current_path = [[2,3]]
other_choices = {}
target = [4,6]
# other_choices = {[2,4]=>[[2,5]]}
p move_a_step(current_path,other_choices,map)
# p current_path
# p other_choices
#
# puts 'next move'
# move_a_step(current_path,other_choices,map)
# p current_path
# p other_choices
#
# puts 'next move'
# move_a_step(current_path,other_choices,map)
# p current_path
# p other_choices
#
# puts 'next move'
# move_a_step(current_path,other_choices,map)
# p current_path
# p other_choices


# p other_choices.keys.last
# hash = {ab:1,cd:2}
# p hash.keys
# a = [1,2,3,4,5]
# a = a[0...2]
# # p b
# p a



def search(map,starting_position,target)
  current_path = [starting_position.dup]
  current_position = starting_position

  moved = false

  alternatives = {}

  if map[current_position[0]-1][current_position[1]]
    puts 'move north'
    current_position[0] = current_position[0] - 1
    current_path << current_position
    moved = true
  end
  if map[current_position[0]][current_position[1]+1]
    if moved
      alternative = current_position.dup
      alternative[1] = alternative[1] + 1
      alternatives[current_position] ||= []
      alternatives[current_position] << alternative
    else
      current_position[1] = current_position[1] + 1
      current_path << current_position.dup
      moved = true
    end
  end
  if map[current_position[0]+1][current_position[1]]
    if moved
      alternative = current_position.dup
      alternative[0] = alternative[0] + 1
      alternatives[current_position] ||= []
      alternatives[current_position] << alternative
    else
      current_position[0] = current_position[0] + 1
      current_path << current_position.dup
      moved = true
    end
  end



  current_path
  alternatives
end

# p search(map,starting_position,target)
