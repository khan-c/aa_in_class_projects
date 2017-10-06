require 'byebug'
class Tile

  attr_reader :position, :board
  attr_accessor :value, :bombed, :flagged, :revealed


  def initialize(row, col, board)
    @bombed = false
    @flagged = false
    @revealed = false
    @value = 0
    @position = [row, col]
    @board = board
  end

  def reveal
    @revealed = true
    return true if bombed == true
    if value == 0
      neighbors.each do |neighbor|
        neighbor.reveal unless neighbor.revealed
      end
    end

    false
  end

  def neighbors
    #check pos against board
    my_neighbors = []
    pos_arr = [[-1,0], [-1,-1], [0,-1], [1,-1], [1,0], [1,1],[0,1],[-1,1]]

    pos_arr.each do |pos|
      neighbor_pos = find_neighbor_pos(pos)
      my_neighbors << board[neighbor_pos] unless out_of_bounds?(neighbor_pos)
    end

    my_neighbors
  end

  def out_of_bounds?(pos)
    pos[0] < 0 || pos[0] > board.grid.length - 1 || pos[1] < 0 || pos[1] > board.grid[0].length  - 1
  end

  def find_neighbor_pos(rel_pos)
    [position[0] + rel_pos[0], position[1] + rel_pos[1]]
  end

  def plant
    @bombed = true
    neighbors.each do |neighbor|
      neighbor.value += 1
    end
  end

end
