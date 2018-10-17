class Reservation < ApplicationRecord
  belongs_to :reserver

  validates :arrival_date, :departure_date, :confirmed, :fee, :party_size, :reserver_id, presence: true
  validates :party_size, numericality: {greater_than: 0, less_than_or_equal_to: 6}
end
