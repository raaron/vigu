class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_locale

  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end

  # def switch_to_admin_view
  #   set_is_in_admin_mode(true)
  # end

  # def switch_to_normal_view
  #   set_is_in_admin_mode(false)
  # end

  def set_locale
    if Rails.env.test?
      return
    end

    if params.has_key?(:locale)
      I18n.locale = params[:locale]
      logger.debug "Set locale from params: #{I18n.locale}"
    elsif !params.has_key?(:locale) && !request.env['HTTP_ACCEPT_LANGUAGE'].nil?
      I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      logger.debug "Set locale from HTTP_ACCEPT_LANGUAGE: #{I18n.locale}"
    else
      I18n.locale = I18n.default_locale
      logger.debug "Set locale to default: #{I18n.locale}"
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  private
    def logged_in_user
      unless is_logged_in?
        store_location
        redirect_to login_url, notice: "Please log in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless is_admin?
    end

end
