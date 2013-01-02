class SessionsController < ApplicationController
  include ApplicationHelper

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      if is_admin?
        set_is_in_admin_mode(true)
      end
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    set_is_in_admin_mode(false)
    redirect_to root_url
  end

end
