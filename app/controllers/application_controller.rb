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

  #ensures that someone is legged in
    def is_logged_in?
      if current_reserver == nil
        flash[:alert]="Please log in"
        redirect_to client_login_url
      end
    end
    #checks that the logged in reserver is the owner of the show page
      def current_is?(id)
        current_reserver.id == id
      end

    # ensures the logged in user is the owner of the page
      def has_access?(id)
        unless current_is?(id)
          flash[:alert]="Sorry you don't have accesss to that."
          return false
        end
        true
      end

      def is_admin?(user)
        user.admin
      end



end
