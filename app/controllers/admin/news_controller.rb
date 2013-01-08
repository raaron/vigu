class Admin::NewsController < Admin::SingleParagraphPageController

  def initialize
    @page = Page.find_by_name(:news)
    super
  end

  def new
    paragraph = super
    redirect_to edit_admin_news_path(paragraph)
  end
end