class Reservation < ApplicationRecord

  belongs_to :reserver
  validates :arrival_date, :departure_date, :confirmed, :fee, :party_size, presence: true
  validates :party_size, numericality: {greater_than: 0, less_than_or_equal_to: 6}
  validate :dates_must_be_available
  validate :dates_must_be_in_future
  validate :dates_must_be_within_one_year
  validate :stay_must_be_up_to_14_days
  validate :arrvial_date_before_departure_date
  validate :minimum_stay

  def dates_must_be_available
    new_range=(arrival_date..departure_date).to_a
    if self.id !=nil
      new_range.each do |date|
        if Reservation.where("arrival_date <= ? AND departure_date >= ? AND id != ?", date, date, self.id).exists? &&
          errors.add(:arrival_date, "It looks like those dates are already booked")
          return
        end
      end
    else
      new_range.each do |date|
        if Reservation.where("arrival_date <= ? AND departure_date >= ?", date, date).exists? &&
          errors.add(:arrival_date, "It looks like those dates are already booked")
          return
        end
      end
    end
  end

  def dates_must_be_in_future
    if arrival_date <= Date.today
      errors.add(:arrival_date, "The arrival date must be in the future")
    end
    if departure_date <= Date.today
      errors.add(:departure_date, "The departure date must be in the future")
    end
  end

  def dates_must_be_within_one_year
    if arrival_date > Date.today.advance(years: 1)
      errors.add(:arrival_date, "The arrival date must be less than one year away")
    end
    if departure_date > Date.today.advance(years: 1)
      errors.add(:departure_date, "The departure date must be less than one year away")
    end
  end

  def stay_must_be_up_to_14_days
    if (departure_date - arrival_date).to_i > 14
      errors.add(:arrival_date, "Stays can't be longer than two weeks")
    end
  end

  def arrvial_date_before_departure_date
    if arrival_date > departure_date
      errors.add(:arrival_date, "The arrival date must be before the departure date")
    end
  end

  def minimum_stay
    if (departure_date - arrival_date).to_i < 3
      errors.add(:arrival_date, "The minimum stay is three nights")
    end
  end

end
