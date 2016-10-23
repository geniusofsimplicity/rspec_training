class StringCalculator
	def self.add(numbers_s)
		sum = 0
		numbers_a = numbers_s.scan(/\d+/)
		numbers_a.each do |n|
			sum += n.to_i	if n.size < 4		
		end
		sum
	end	
end

puts StringCalculator.add("")