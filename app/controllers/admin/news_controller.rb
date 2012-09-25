class Admin::NewsController < Admin::PageController

  def initialize
    @page = Page.find_by_name('news')
    super
  end

end