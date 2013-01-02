class ParagraphsController < ApplicationController
  def index
    @items = Paragraph.all
  end

  def show
    @paragraph = Paragraph.find_by_id(params[:id])
  end

  def new
    @paragraph = Paragraph.new(page: Page.first, section: "main", default_title: "", default_body: "", title: "", body: "", date: Date.today)
  end

  def edit
    @paragraph = Paragraph.find_by_id(params[:id])
  end

  def create
    p = params[:paragraph]
    title = p[:title]
    body = p[:body]
    @paragraph = Paragraph.new(p.merge(:page => Page.first, :section => "main"))

    if @paragraph.save
      pic_attributes = params[:paragraph][:images_attributes]
      if pic_attributes
        @paragraph.update_caption_translation(pic_attributes)
      end
    else
      flash.notice = @paragraph.errors.full_messages
    end
    redirect_to edit_paragraph_path(@paragraph)
  end

  def update
    @paragraph = Paragraph.find_by_id(params[:id])
    if @paragraph.update_attributes(params[:paragraph])
      @paragraph.update_caption_translation(params[:paragraph][:images_attributes])
    else
      flash.notice = "ERROR" + @paragraph.errors.full_messages.to_s
    end

    redirect_to edit_paragraph_path(@paragraph)
  end

  def destroy
    @paragraph = Paragraph.find(params[:id])
    @paragraph.destroy
    redirect_to request.referrer

    # respond_to do |format|
    #   format.html { redirect_to paragraphs_url }
    #   format.json { head :no_content }
    # end
  end
end
