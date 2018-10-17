class Reserver < ApplicationRecord
  has_many :reservations

  validates :title, :first_name, :last_name, :contact_number,
   :id_type, :id_number, :house_number, :street_name, :city, :country, :postcode,  presence: true
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email_address, presence: true,  format: {with: VALID_EMAIL_REGEX }, confirmation: {case_sensitive: false}
  validates :email_address_confirmation, presence: true
  
end
