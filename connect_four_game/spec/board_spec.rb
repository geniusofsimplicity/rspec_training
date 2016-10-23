require "connect_4.rb"

describe Connect4::Board do
	let(:fake_console) { allow(Object).to receive(:gets).and_return("pl1", "pl2") }
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
		let(:move){ rand(0..6) }

		context "checking correct move" do			
			it { expect(create_board.send(:valid_move?, move)).to be true }			
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
			it { expect(create_board.print_board).to eql(board_result_empty) }			
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

			it { expect(board_with_two_moves.print_board).to eql(board_expected.join("\n")) }			
		end
	end
end