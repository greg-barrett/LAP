class ReserverSessionsController < ApplicationController
  def new
  end

  def create
    @reserver=Reserver.find_by(email_address: params[:email_address])
    if @reserver && @reserver.authenticate(params[:password])
      session[:reserver_id]=@reserver.id
      flash[:notice]="You are now logged in"
      return redirect_to reserver_path(@reserver)
    else
      flash.now[:alert]="Email or password is incorrect"
      render "new"
    end
  end

  def destroy
    session[:reserver_id]=nil
    cookies.delete :reserver_id if cookies.encrypted[:reserver_id]
    current_reserver
    flash[:notice]="You have successfully logged out"
    redirect_to root_url
  end


end
