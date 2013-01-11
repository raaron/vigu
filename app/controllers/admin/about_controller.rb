class Admin::AboutController < Admin::MultiParagraphPageController

  def initialize
    @page = Page.find_by_name(:about).becomes(About)
    @people_collection = @page.get_paragraph_collection(:people)
    @work_collection = @page.get_paragraph_collection(:work)
    super
  end

end