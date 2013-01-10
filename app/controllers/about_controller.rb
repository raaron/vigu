class AboutController < ApplicationController
  def show
    @page = Page.find_by_name(:about)
  end
end
