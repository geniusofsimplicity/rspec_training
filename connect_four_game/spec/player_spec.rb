require "connect_4.rb"

describe Connect4::Player do	
	let(:player1_name) { "pl1" }
	let(:player2_name) { "pl2" }
	let(:fake_console) { allow(Object).to receive(:gets).and_return(player1_name, player2_name) }
	describe ".get_name" do
		context "working with console" do
			it "asking for name" do				
				expect(Object).to receive(:puts)				
				fake_console
				Connect4::Player.get_name
			end
			it "receiving name" do				
				expect(Object).to receive(:gets)				
				fake_console
				Connect4::Player.get_name
			end
		end
	end

	describe ".create" do 		
		context "expecting to send calls" do
			it "to get_name" do
				expect(Connect4::Player).to receive(:get_name).once
				Connect4::Player.create
			end

			it "to new" do
				allow(Connect4::Player).to receive(:get_name).and_return("")
				expect(Connect4::Player).to receive(:new).once
				Connect4::Player.create
			end
		end

		context "expecting players to have different chips" do			
			let(:player1) do
				fake_console
				Connect4::Player.create
			end
			let(:player2) do
				fake_console
				Connect4::Player.create
			end
			it "asigned 'x' to player1" do
				expect(player1.instance_variable_get(:@chip)).to eql("x")
			end
			it "asigned 'y' to player2" do
				expect(player2.instance_variable_get(:@chip)).to eql("y")
			end
		end
	end
	describe "#to_s" do
		context "overriding the method, name" do
			let(:player) do
				fake_console
				Connect4::Player.create
			end
			it do
				expect(player.to_s).to eql(player1_name)
			end
		end
	end
end