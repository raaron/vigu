class Admin::ApplicationController < ApplicationController
  protect_from_forgery
  include ApplicationHelper

  def switch_to_admin_view
    set_is_in_admin_mode(true)
    redirect_to params[:admin_view_path]
  end

  def switch_to_normal_view
    set_is_in_admin_mode(false)
    redirect_to params[:normal_view_path]
  end

end
