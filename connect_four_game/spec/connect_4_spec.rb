require "connect_4"

describe Connect4 do

	# TODO: Replace with real object once setup
	#				method is ready
	# 			let(:game){double("Connect four game")}
	let(:player1) do 
		player1 = double("Bob")
		allow(player1).to receive(:chip).and_return("x")
		player1
	end	
	let(:player2) do 
		player2 = double("Nick")
		allow(player2).to receive(:chip).and_return("x")
		player2
	end

	let(:block_output){ allow(Object).to receive(:puts){ nil } }

	let(:game){Connect4.new(player1, player2)}
	
	describe ".initialize" do		
		context "setting up" do
			it "players" do						
				expect(game.instance_variable_get(:@player1)).to eql(player1)
				expect(game.instance_variable_get(:@player2)).to eql(player2)
			end

			it "board" do
				expect(game.instance_variable_get(:@board)).to be_a(Connect4::Board)
			end
		end
	end
	
	describe ".setup" do		
		context "setting up game object" do		
			let(:new_game) do 
				# fake_console
				Connect4.setup
			end
			let(:player_class) do
				player_class = class_double("Connect4::Player").as_stubbed_const
				allow(player_class).to receive(:create).and_return(player1, player2)
			end

			it do
				block_output
				player_class
				expect(new_game).to be_a(Connect4)				
			end			
			
			it "creates new players" do
				block_output
				player_class
				expect(Connect4::Player).to receive(:create).twice
				Connect4.setup
			end

			let(:fake_console) { allow(Object).to receive(:gets).and_return("pl1", "pl2") }

			it "choosing first player" do				
				block_output
				fake_console
				expect(new_game.instance_variable_get(:@current_player)).to be_instance_of Connect4::Player				
			end

			context "creating new board" do
				it do
					block_output
					player_class
					expect(Connect4::Board).to receive(:create).once
					Connect4.setup
				end
			end
		end
	end

	describe "#start" do
		context "deligating work to handle_turn method" do
			it do
				block_output
				expect(game).to receive(:handle_turn).at_least(1)
				game.start
			end
		end
	end

	describe "#handle_turn" do
		let(:block_get_move){ allow(game).to receive(:get_move){ nil } }		
		let(:board) { game.instance_variable_get(:@board) }			
		context "deligating printing board" do
			it do
				block_get_move
				block_output				
				expect(board).to receive(:print_board).at_least(1)								
				game.send(:handle_turn)
			end
		end

		context "deligating to check board" do			
			it do
				block_get_move
				block_output
				expect(board).to receive(:end_of_game?).at_least(1)								
				game.send(:handle_turn)
			end
		end

		context "calling @board.add_move" do
			let(:board) { game.instance_variable_get(:@board) }			
			
			it do
				block_get_move
				block_output
				expect(board).to receive(:add_move).at_least(1)								
				game.send(:handle_turn)
			end
		end

		context "deligated to get move" do			
			it do	
				block_get_move
				block_output
				expect(game).to receive(:get_move).at_least(1)
				game.send(:handle_turn)				
			end
		end
	end
end