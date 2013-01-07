class PartnersController < ApplicationController

  def index
    @page = Page.find_by_name('partners')
  end

end
