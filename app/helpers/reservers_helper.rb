module ReserversHelper
  def future_reservations
    array=@reserver.reservations.select do |x|
      x.arrival_date >= Date.today
    end
    return array
  end

  def past_reservations
    array=@reserver.reservations.select do |x|
      x.arrival_date < Date.today
    end
    return array
  end

end
