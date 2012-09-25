class NewsController < ApplicationController

  def index
    @page = Page.find_by_name('news')
  end

end
