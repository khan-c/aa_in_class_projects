require 'colorize'
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
      @game_over = false
    end

    grid.flatten.sample(10).each do |tile|
      tile.plant
    end
  end

  def render
    puts "   #{(0...grid.length).to_a.join("  ")}"

    grid.each_with_index do |row, idx|
      print "#{idx} "

      row.each do |tile|
        if tile.revealed
          if tile.bombed? == false
            print tile.value == 0 ? "   " : " #{tile.value} ".colorize(:blue)
          else
            print " \u{1F4A5} "
          end
        elsif tile.flagged?
          print " F ".colorize(:light_red)
        else
          print " * "
        end
      end

      puts ""
    end
  end

  def reveal(pos)
    tile  = self[pos]
    if tile.flagged?
      puts "This tile is flagged and cannot be revealed."
    else
      @game_over = tile.reveal
    end
  end

  def toggle_flag(pos)
    tile = self[pos]
    tile.flagged? ? tile.remove_flag : tile.plant_flag
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def game_over?
    @game_over
  end

  def won?
    bombless_tiles = @grid.flatten.reject { |tile| tile.bombed? }
    bombless_tiles.all? { |tile| tile.revealed? }
  end

  def valid_move?(pos)
    pos.all? { |x| (0...@grid.length).cover?(x) } || !self[pos].revealed? || !self[pos].flagged?
  end
end
