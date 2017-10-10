require_relative 'board'
require_relative 'tile'

class MoveTypeError < StandardError
  def message
    "Not a valid option. Please enter either 'r' to reveal a position or 'f' to plant/remove a flag."
  end
end

class CoordError < StandardError
  def message
    "Not a valid coordinate. Please enter a coordinate within the range of the board."
  end
end

class Game

  def initialize(board)
    @board = board
  end

  def play
    system("clear")
    puts "Welcome to Minesweeper!"
    puts "\nTry to reveal the field, but be careful, don't reveal a bomb!"
    sleep(3)

    until game_over?
      display
      take_turn
    end

    display
    puts @board.won? ? "You win!" : "Blown to smithereens :("
  end

  def take_turn
    begin
      move_type = prompt_type_of_move
    rescue MoveTypeError => e
      puts e.message
      retry
    end

    begin
      pos = prompt_coord
    rescue  CoordError => e
        puts e.message
        retry
    end

    case move_type
    when :flag
      toggle_flag(pos)
    when :reveal
      reveal(pos)
    end
  end

  def prompt_type_of_move
    puts "What would you like to do? Enter 'r' to reveal, 'f' to place/remove a flag"
    move = gets.chomp.strip
    if !%w(r f R F).include?(move)
      raise MoveTypeError
    end

    case move
    when "r", "R"
      :reveal
    when "f", "F"
      :flag
    end
  end

  def prompt_coord
    puts "Where would you like to take this action (ie. 0,0)?"
    move = parse(gets.chomp)
    if !@board.valid_move?(move)
      raise CoordError
    end
    move
  end

  def parse(input)
    input.split(",").map(&:to_i)
  end

  def toggle_flag(pos)
    @board.toggle_flag(pos)
  end

  def reveal(pos)
    @board.reveal(pos)
  end

  def display
    system("clear")
    @board.render
  end

  def game_over?
    @board.game_over? || @board.won?
  end

end

if $PROGRAM_NAME == __FILE__
  board = Board.new
  Game.new(board).play
end
