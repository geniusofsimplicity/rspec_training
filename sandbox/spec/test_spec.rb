require "my_class"

describe MyClass do

	# describe "attributes" do
		
		# subject do
		# 	MyClass.new(:duration => 32,
		# 					:distance => 5.2,
		# 					:timestamp => "2014-12-22 20:30")
		# end

		it { is_expected.to respond_to(:duration)}
		it { is_expected.to respond_to(:distance)}
		it { is_expected.to respond_to(:timestamp)}		
		it { expect(MyClass.new.duration).to eql(5)}

	# end
end