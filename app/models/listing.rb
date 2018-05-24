class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence:true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  after_save :set_user_as_a_host, on: :create
  before_destroy :set_user_host_to_false, on: :destroy

  def average_review_rating
  	total_rating = 0
    # binding.pry
  	self.reviews.each do |review|
  		total_rating += review.rating
  	end
  	total_rating.to_f / self.reviews.count.to_f
  end

  def check_availability(starting_date, ending_date)
    ap_availability = true
    self.reservations.each do |reservation|
      if (reservation.checkin <= starting_date.to_date && reservation.checkout >= ending_date.to_date) || (reservation.checkin >= starting_date.to_date && reservation.checkin <= ending_date.to_date) || (reservation.checkout >= starting_date.to_date && reservation.checkout <= ending_date.to_date)
      ap_availability = false
      end
    end
    ap_availability
  end

  private

  def set_user_as_a_host
  	self.host.update(host: true)
  end

  def set_user_host_to_false
  	if self.host.listings.length == 1
  		self.host.update(host: false)
  	end	
  end
end
