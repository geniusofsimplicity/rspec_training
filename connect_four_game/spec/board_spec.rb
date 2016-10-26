require "connect_4.rb"

describe Connect4::Board do
	let(:fake_console) do
		allow(Object).to receive(:gets).and_return("pl1", "pl2")
		allow(Object).to receive(:puts){ nil }
	end
	let(:create_board) do
		fake_console
		Connect4::Board.create
	end	
	let(:board_values){ create_board.instance_variable_get(:@board) }
	let(:player_token){ double("player_token") }
	context "creating new board" do		
		it "calling create" do
			expect(Connect4::Board).to receive(:new).once
			Connect4::Board.create
		end

		it "returning Board object" do
			expect(create_board).to be_a Connect4::Board
		end

		it "having empty hash" do			
			expect(board_values).to be_an_instance_of Hash
			expect(board_values.size).to eql(0)
		end
	end

	describe "#end_of_game?" do		
		let(:player1) do 
			player1 = double("Bob")
			allow(player1).to receive(:chip).and_return("x")
			player1
		end	
		let(:player2) do 
			player2 = double("Nick")
			allow(player2).to receive(:chip).and_return("y")
			player2
		end
		let(:winner) { [player1, player2].sample }

		def setup_board_up_to(n)# n > 0
			board = create_board
			filled_board_x = [[[0, 0], [0, 1], [0, 4], [0, 5]],
												[[1, 2], [1, 3], [1, 6]],
												[[2, 0], [2, 1], [2, 4], [2, 5]],
												[[3, 2], [3, 3], [3, 6]],
												[[4, 0], [4, 1], [4, 4], [4, 5]],
												[[5, 2], [5, 3], [5, 6]]]
			filled_board_y = [[[0, 2], [0, 3], [0, 6]],
												[[1, 0], [1, 1], [1, 4], [1, 5]],
												[[2, 2], [2, 3], [2, 6]],
												[[3, 0], [3, 1], [3, 4], [3, 5]],
												[[4, 2], [4, 3], [4, 6]],
												[[5, 0], [5, 1], [5, 4], [5, 5]]]
			rows_below = n
			filled_board_x_below = filled_board_x.first(rows_below)
			filled_board_y_below = filled_board_y.first(rows_below)
			rows_below.times do |i|
				row_x = filled_board_x[i]				
				row_x.each do |move|					
					board.add_move(move[1], player1.chip)
				end
				row_y = filled_board_y[i]
				row_y.each do |move|
					board.add_move(move[1], player2.chip)
				end
			end
			board			
		end

		let(:setup_board) do
			setup_board_up_to(rand(5) + 1)
		end
		let(:setup_board_by_row) do				
				start_column = rand(4)
				board = setup_board
				start_column.upto(start_column + 3) { |i| board.add_move(i, winner.chip) }
				board
			end
		context "resolving positively" do
			let(:setup_board_by_column) do
				board = create_board
				column = rand(7)
				4.times { board.add_move(column, winner.chip) }				
				board
			end

			let(:setup_board_diagonally_1) do
				top_row = rand(3) + 4				
				board = setup_board_up_to(top_row)
				board_values = board.instance_variable_get(:@board)				
				row_start = rand(3..top_row - 1)
				column_start = rand(4)				
				start_pos = [row_start, column_start]
				4.times do |i|
					board_values[[start_pos[0] - i, start_pos[1] + i]] = winner.chip
				end
				board.instance_variable_set(:@board, board_values)
				board
			end

			let(:setup_board_diagonally_2) do
				top_row = rand(3) + 4				
				board = setup_board_up_to(top_row)
				board_values = board.instance_variable_get(:@board)				
				row_start = rand(0..top_row - 4)
				column_start = rand(4)				
				start_pos = [row_start, column_start]
				4.times do |i|
					board_values[[start_pos[0] + i, start_pos[1] + i]] = winner.chip
				end
				board.instance_variable_set(:@board, board_values)
				board
			end

			it "having 4 chips in lowering diagonal" do
				expect(setup_board_diagonally_1.end_of_game?).to be true
			end

			it "having 4 chips in rising diagonal" do
				expect(setup_board_diagonally_2.end_of_game?).to be true
			end

			it "having 4 chips in one column" do
				expect(setup_board_by_column.end_of_game?).to be true
			end

			it "having 4 chips in one row" do
				expect(setup_board_by_row.end_of_game?).to be true
			end
		end

		context "resolving negatively" do
			it "having an empty board" do				
				expect(create_board.end_of_game?).to be_falsey
			end			

			it "having a non-winning board" do				
				expect(setup_board.end_of_game?).to be_falsey
			end
		end
	end
	
	describe "#get_column" do
		context "putting 3 tokens in the same solumn" do
			let(:board) do
				board = create_board
				3.times {board.add_move(2, "y")}
				board
			end
			let(:expected_hash){ {[0, 2] => "y", [1, 2] => "y", [2, 2] => "y"} }

			it { expect(board.send(:get_column, 2)).to eql(expected_hash) }
		end
	end

	describe "#add_move" do		
		context "adding correct move" do			
			let(:move){ rand(0..6) }

			it do
				expect(create_board.add_move(move, player_token)).to be_truthy
			end
		end

		context "adding incorrect (negative) move" do			
			let(:move){ rand(-110..-1) }
			
			it do
				create_board.add_move(move, player_token)
				expect(board_values[move]).not_to eql(player_token)
			end
		end

		context "calling valid_move?" do			
			let(:move){ double("move") }
			it do
				expect(create_board).to receive(:valid_move?).with(move).once
				create_board.add_move(move, player_token)
			end
		end
	end

	describe "#valid_move?" do		
		let(:move){ rand(1..5) }

		context "checking correct move" do			
			it { expect(create_board.send(:valid_move?, move)).to be true }			

			it { expect(create_board.send(:valid_move?, 6)).to be true }

			it { expect(create_board.send(:valid_move?, 0)).to be true }
		end

		context "checking incorrect move" do
			let(:incorrect_move){ rand(-110..-1) }

			it {	expect(create_board.send(:valid_move?, incorrect_move)).to be false }			
		end

		context "trying to add to a full column" do
			it do
				board = create_board
				current_move = move
				6.times { board.add_move(current_move, player_token) }				
				expect(board.send(:valid_move?, current_move)).to be_falsey
			end
		end
	end

	describe "#print_board" do
		let(:board_result_empty){ create_board.instance_variable_get(:@background) }

		context "checking empty board" do
			it do
				fake_console
				expect(create_board.print_board).to eql(board_result_empty)				
			end
		end

		context "having 2 moves added" do
			let(:board_with_two_moves) do 
				board = Connect4::Board.create
				board.add_move(0, "x")
				board.add_move(5, "x")
				board
			end

			let(:board_expected) do
				board = board_result_empty.split("\n")
				board[5][3] = "x"
				board[5][13] = "x"
				board		
			end

			it do
				fake_console
				expect(board_with_two_moves.print_board).to eql(board_expected.join("\n"))
			end
		end
	end
end