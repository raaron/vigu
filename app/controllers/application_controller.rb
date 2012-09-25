class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_locale

  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end

  def set_locale
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

end
