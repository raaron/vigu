class HomeController < ApplicationController

  def show
    @page = Page.find_by_name('home')
  end

end
