def scan_possible_moves(path,map)
  pos = path.last
  possible_moves = []
  x_max, y_max = map.length - 1, map.first.length - 1
  possible_moves << [pos[0]-1,pos[1]] if 0 <= pos[0]-1 && map[pos[0]-1][pos[1]]
  possible_moves << [pos[0],pos[1]+1] if pos[1]+1 <= y_max && map[pos[0]][pos[1]+1]
  possible_moves << [pos[0]+1,pos[1]] if pos[0]+1 <= x_max && map[pos[0]+1][pos[1]]
  possible_moves << [pos[0],pos[1]-1] if 0 <= pos[1]-1 && map[pos[0]][pos[1]-1]
  going_back_removed = possible_moves - path
end

def move_a_step(current_path,other_choices,map,target)
  return [] if map == [[true]]
  possible_moves = scan_possible_moves(current_path,map)
  if possible_moves != []
    next_move = possible_moves.delete_at(0)
    other_choices[current_path.last] = possible_moves if possible_moves != []
    current_path << next_move
  else
    last_junction = other_choices.keys.last.dup
    junction_index = current_path.index(last_junction)
    current_path.delete_if{|pos| current_path.index(pos) > junction_index}
    next_move = other_choices[current_path.last].delete_at(0)
    other_choices.delete(current_path.last) if other_choices[current_path.last] == []
    current_path << next_move
  end
  if current_path.last == target
    return current_path
  else
    move_a_step(current_path,other_choices,map,target)
  end
end

def path_to_instruction(path)
  instruction = []
  for i in 0...path.length - 1
    instruction << 'right' if path[i][1] < path[i+1][1]
    instruction << 'left' if path[i][1] > path[i+1][1]
    instruction << 'down' if path[i][0] < path[i+1][0]
    instruction << 'up' if path[i][0] > path[i+1][0]
  end
  return instruction
end

def solve(minemap, miner, exit)
    current_path = [[miner['x'],miner['y']]]
    target = [exit['x'],exit['y']]
    other_choices = {}
    move_a_step(current_path,other_choices,minemap,target)
    path_to_instruction(current_path)
end

small_mine_map = [
  [false, false,  true,   false,  true,   false,  true],
  [false, false,  true,   false,  true,   false,  true],
  [true,  true,   true,   true,   true,   true,   true],
  [true,  false,  true,   false,  true,   false,  true],
  [true,  false,  true,   false,  true,   false,  true]
]
miner_1 = {'x'=>0, 'y'=>6}
exit_1 = {'x'=>4, 'y'=>0}
p solve(small_mine_map, miner_1, exit_1)
#=> ["down", "down", "left", "left", "left", "left", "left", "left", "down", "down"]

large_mine_map = [
  [false, false,  true,   false,  true,   false,  true,   false,  true,    true],
  [false, false,  true,   false,  true,   false,  true,   false,  true,   false],
  [true,  true,   true,   true,   true,   true,   true,   false,  true,   false],
  [true,  false,  true,   false,  true,   false,  true,   false,  true,    true],
  [true,  false,  true,   false,  true,   false,  true,    true,  true,   false],
  [true,  false,  true,   false,  false,  false,  true,   false,  true,   false],
  [true,  false,  true,   false,  true,   false,  true,   false,  true,    true],
  [true,  false,  true,   false,  true,    true,  true,   false,  true,   false],
  [true,  false,  true,   false,  true,   false,  true,   false,  true,   false],
  [true,  false,  true,   false,  true,   false,  true,   false,  true,   false],
  [true,  false,  true,   false,  true,   false,  false,   true,  true,   false]
]
miner_2 = {'x'=>0, 'y'=>9}
exit_2 = {'x'=>10, 'y'=>0}
p solve(large_mine_map, miner_2, exit_2)
# => ["left", "down", "down", "down", "down", "left", "left", "up", "up", "left",
#     "left", "left", "left", "left", "left", "down", "down", "down", "down",
#     "down", "down", "down", "down"]

# New challenge -
# 1.  make a map generator  def generate_map(n,m) #creating a tree with no loops will
#     be the main challenge!
# 2.  make a walk_bot, which when given a starting position, path, destination, will
#     attempt to walk the path given, returns true if it gets to the destination
#     unscathed, return false in all other cases.
