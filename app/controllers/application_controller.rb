class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_reserver


  def date_is_valid?(day, month, year)
    begin
      date=(year + "-" + month + "-" + day).to_date
    rescue ArgumentError
      return false
    end
    true
  end

  def current_reserver
    if session[:reserver_id]
      @current_reserver ||= Reserver.find(session[:reserver_id])
    else
      @current_reserver=nil
    end
  end
end
