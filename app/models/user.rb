class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations

	def hosts
		host_list = []
		self.trips.each do |trip|
			host_list << trip.listing.host
		end
		host_list
	end

	def host_reviews
		host_rev = []
		self.listings.each do |listing|
			listing.reviews.each do |review|
				host_rev << review
			end
		end
		host_rev
	end
  
end
