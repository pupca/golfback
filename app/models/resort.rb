class Resort < ActiveRecord::Base
	geocoded_by :full_street_address   # can also be an IP address
	after_validation :geocode          # auto-fetch coordinates

	has_many :categories#, :include => [:c]

	def full_street_address
		return self.address
	end
end
