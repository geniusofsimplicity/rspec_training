class MyClass
	attr_reader :duration, :distance, :timestamp
	def initialize(*hash)
		@duration = hash.size > 0 ? hash[:duration] : 5
		@distance = hash.size > 0 ? hash[:distance] : 4.2		
		@timestamp = hash.size > 0 ? hash[:timestamp] : "2014-12-22 20:30"
	end
end