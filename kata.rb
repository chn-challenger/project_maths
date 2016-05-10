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

def move_a_step(current_path,other_choices,map)
  possible_moves = scan(current_path.last,current_path,map)
  if possible_moves != []
    next_move = possible_moves.delete_at(0)
    current_path << next_move
    other_choices[current_path.last] = possible_moves
  else
    # next_move = other_choices.last
    # find distance 1 position in current patfh compared with last choice
    # delete all moves after that
  end
  other_choices
  current_path
end

map = [
  [false, false,  true,   false,  true,   false,  true],
  [false, false,  true,   true,   true,   false,  true],
  [true,  true,   true,   true,   true,   true,   true],
  [true,  false,  true,   false,  true,   false,  true],
  [true,  false,  true,   false,  true,   false,  true]
]

current_path = [[3,4],[2,4]]
other_choices = {}
p move_a_step(current_path,other_choices,map)


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
