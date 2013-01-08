class Admin::PartnersController < Admin::SingleParagraphPageController

  def initialize
    @page = Page.find_by_name(:partners)
    super
  end

  def new
    paragraph = super
    redirect_to edit_admin_partner_path(paragraph)
  end
end