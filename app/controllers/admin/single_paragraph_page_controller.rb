class Admin::SingleParagraphPageController < Admin::PageController

  def edit
    @paragraph = Paragraph.find_by_id(params[:id])
  end

  def update
    link_text = " link(#{t(:visible_text)}, #{t(:invisible_url)}) "
    if params[:add_link_default]
      params[:paragraph][:default_body] += link_text
    elsif params[:add_link]
      params[:paragraph][:body] += link_text
    end
    @paragraph = Paragraph.find_by_id(params[:id])
    if @paragraph.update_attributes(params[:paragraph])
      @paragraph.update_caption_translation(params[:paragraph][:images_attributes])
    else
      flash.notice = "ERROR" + @paragraph.errors.full_messages.to_s
    end
    redirect_to request.referrer
  end

  def sort
    params[:paragraph].each_with_index do |id, index|
      Paragraph.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
end