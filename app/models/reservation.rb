class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :no_self_checkin
  validate :availability_check
  validate :check_dates

  def duration
 	self.checkout - self.checkin
  end

  def total_price
  	self.duration.to_i*self.listing.price
  end

  private

  def no_self_checkin
  	if self.guest == self.listing.host
  		self.errors.add(:guest_id, "You can't self checkin")
  		false
  	else
  		true
  	end
  end

  def availability_check
  	if !self.checkin.nil? && !self.checkout.nil?
  		if self.listing.check_availability(self.checkin.to_s, self.checkout.to_s)
  			true
  		else
  			self.errors.add(:checkin, "these dates are not available")
  			false
  		end
  	else
  		self.errors.add(:checkin, "checkin or checkout cannot be nil")
  		false
  	end
  end

  def check_dates
  	if !self.checkin.nil? && !self.checkout.nil?
	  	if self.checkin >= self.checkout
	  		self.errors.add(:checkin, "checkin date should be before checkout date")
	  	end
  	else
  		self.errors.add(:checkin, "checkin or checkout cannot be nil")
  		false
  	end
  end

end
