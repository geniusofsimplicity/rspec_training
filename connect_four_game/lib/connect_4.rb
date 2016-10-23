class Connect4

	class Board
		def self.create
			board = Board.new			
		end

		def add_move(move, sign)
			if valid_move?(move)
				top = get_column(move).size				
				@board[[top, move]] = sign				
				return true
			end			
		end

		def print_board
			place_moves			
		end

		private

		def place_moves
			background = @background.split("\n")			
			@board.each do |pos, mark|
				background[5 - pos[0]][3 + pos[1] * 2] = mark
			end
			background.join("\n")
		end
				
		def get_column(move)
			@board.select { |k, value| k[1] == move }			
		end
		
		def valid_move?(move)
			(0..5).include?(move) && get_column(move).size < 6
		end
		
		def initialize
			@board = Hash.new()
			@background = "6| _ _ _ _ _ _ _\n5| _ _ _ _ _ _ _\n4| _ _ _ _ _ _ _\n3| _ _ _ _ _ _ _\n2| _ _ _ _ _ _ _\n1| _ _ _ _ _ _ _\n================\n | 1 2 3 4 5 6 7"	
		end
	end

	class Player
		@@chips = [] # one session at a time is allowed
		attr_reader :chip
		def self.create
			name = get_name
			self.new(name)
		end

		def to_s
			@name			
		end

		private
		def initialize(name)
			@name = name
			@@chips = ["x", "y"] if @@chips.size == 0
			@chip = @@chips.pop
		end

		def self.get_name			
			puts "Please, enter your name."
			name = nil
			until name
				name = gets
			end			
			name.chomp
		end
	end

	def self.setup		
		player1 = Player.create
		player2 = Player.create
		self.new(player1, player2)
	end

	def start
		handle_turn		
	end

	private

	def initialize(player1, player2)
		@player1 = player1
		@player2 = player2
		@board = Board.create
		@current_player = rand(2) == 0 ? @player1 : @player2
	end

	def handle_turn
		@board.print_board
		puts "Player #{@current_player}, it is your turn."		
		move = get_move
		@board.add_move(move, @current_player.chip)
	end

	def get_move
		puts "Please, enter the column number (1-7) where to put your chip into."
		column = nil
		ask_again = false
		until (1..7).include?(column)
			puts "Please, enter the number in range from 1 to 7" if ask_again
			column = gets
			column.chomp! if column
			column.to_i			
			ask_again = true
		end
		column - 1		
	end
end