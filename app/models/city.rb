class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(starting_date, ending_date)
  	available_listings = []
  	self.listings.each do |listing|
  		  	ap_availability = true
  		listing.reservations.each do |reservation|
  			if (reservation.checkin <= starting_date.to_date && reservation.checkout >= ending_date.to_date) || (reservation.checkin >= starting_date.to_date && reservation.checkin <= ending_date.to_date) || (reservation.checkout >= starting_date.to_date && reservation.checkout <= ending_date.to_date)
  			
  				ap_availability = false
  			end
  		end
  		if ap_availability == true
  			available_listings << listing
  		end
  	end
  	available_listings
  end

  def self.highest_ratio_res_to_listings
  	self.all.max_by {|city| city.reservations.count/city.listings.count}
  end

  def self.most_res
  	self.all.max_by {|city| city.reservations.count}
  end
end

