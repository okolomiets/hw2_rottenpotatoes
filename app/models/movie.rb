class Movie < ActiveRecord::Base

	def self.ratings
		self.select("DISTINCT rating").collect {|p| p.rating}
	end

end
