require 'byebug'
require_relative 'tile'

class Board

  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    grid.each_index do |row|
      grid[row].each_index do |col|
        grid[row][col] = Tile.new(row, col, self)
      end
    end

    grid.flatten.sample(10).each do |tile|
      tile.plant
    end
  end

  def render
    grid.each do |row|
      row.each do |tile|
        if tile.revealed
          if tile.bombed
            print "*"
          else
            print "#{tile.value}"
          end
        else
          print "X"
        end
      end
      puts ""
    end
  end

  def reveal(pos)
    debugger
    self[pos].reveal
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end


end
