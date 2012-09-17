class Admin::HomeController < ApplicationController

  def show
  end

  def create
    I18n.backend.store_translations(I18n.locale, {:home_title => params[:title]})
    I18n.backend.store_translations(I18n.locale, {:home_descr => params[:descr]})
    redirect_to root_path
  end

end
