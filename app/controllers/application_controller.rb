class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end

  def set_locale
    logger.debug "* Accept-Language: #{ENV['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private
  def extract_locale_from_accept_language_header
    if params[:locale]
      I18n.locale = params[:locale]
    elsif ENV['HTTP_ACCEPT_LANGUAGE']
      ENV['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    else
      I18n.default_locale
    end
  end

end
