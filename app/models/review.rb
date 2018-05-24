class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  # validates :guest_id, presence: true
  validate :check_reservation


  private

  def check_reservation
  	if self.reservation.nil? || self.reservation.checkout > Time.now || self.reservation.status != "accepted"
  		self.errors.add(:reservation_id, "not a valid reservation")
  		false
  	end
  end


end
