class Admin::PageController < Admin::ApplicationController

  before_filter :admin_user

  def new(paragraph)
    paragraph.position = @page.paragraphs.maximum(:position)
    @page.paragraphs = [] unless @page.paragraphs
    @page.paragraphs << paragraph
    paragraph.insert_empty_translation
  end

end
