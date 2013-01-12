class Admin::HomeController < Admin::MultiParagraphPageController

  def initialize
    @page = Page.find_by_name(:home).becomes(Home)
    @people_collection = @page.get_paragraph_collection(:people)
    @work_collection = @page.get_paragraph_collection(:work)
    super
  end

  def sort
    # result = ""
    params[:paragraph].each_with_index do |id, index|
      # result += "Paragraph(#{id}) new position #{index+1} ; "
      Paragraph.update_all({position: index+1}, {id: id})
    end
    # flash.notice = result
    render nothing: true
  end

end