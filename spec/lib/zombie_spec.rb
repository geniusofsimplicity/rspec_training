require "spec_helper"
require "lib/zombie"
describe Zombie do
	# your examples (tests) go here
	it "is named Ash" do
		zombie = Zombie.new
		zombie.name.should == "Ash"
	end

	xit "has no brains" do
		zombie = Zombie.new
		zombie.brains.should < 1
	end

	it "is hungry" do		
		zombie = Zombie.new
		zombie.should be_hungry
	end
end