class Admin::HomeController < Admin::PageController

  def initialize
    @page = Page.find_by_name('home')
    super
  end

end
