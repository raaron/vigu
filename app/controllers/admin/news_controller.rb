class Admin::NewsController < Admin::SingleParagraphPageController

  def initialize
    @page = Page.find_by_name('news')
    super
  end

  def new
    paragraph = Paragraph.new(page: @page, section: 'main', title: "", body: "", date: Date.today)
    super paragraph
    redirect_to edit_admin_news_path(paragraph)
  end
end