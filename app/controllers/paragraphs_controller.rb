class ParagraphsController < ApplicationController
  def index
    @items = Paragraph.all
  end

  def show
    @paragraph = Paragraph.find_by_id(params[:id])
  end

  def new
    @paragraph = Paragraph.new(page: Page.first, section: "main", title: "", body: "")
    respond_to do |format|
      format.html
      format.json { render json: @paragraph }
    end
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
      @paragraph.update_translation
      redirect_to paragraphs_path
    else
      flash.notice = @paragraph.errors.full_messages
      redirect_to paragraphs_path
    end
  end

  def update
    @paragraph = Paragraph.find_by_id(params[:id])
    if @paragraph.update_attributes(params[:paragraph])
      @paragraph.update_caption_translation(params[:paragraph][:images_attributes])
      @paragraph.update_translation
    else
      flash.notice = "ERROR" + @paragraph.errors.full_messages.to_s
    end

    redirect_to paragraphs_path
  end

  def destroy
    @paragraph = Paragraph.find(params[:id])
    @paragraph.destroy

    respond_to do |format|
      format.html { redirect_to paragraphs_url }
      format.json { head :no_content }
    end
  end
end
