class Admin::SingleParagraphPageController < Admin::PageController

  def initialize
    @main_collection = @page.paragraph_collections.find_by_section(:main)
    super
  end

  def new
    Paragraph.create(paragraph_collection: @main_collection,
                     date: Date.today)
  end

  def edit
    @paragraph = Paragraph.find_by_id(params[:id])
  end

  def update
    @paragraph = Paragraph.find_by_id(params[:id])
    if @paragraph.update_attributes(params[:paragraph])
      @paragraph.update_caption_translation(params[:paragraph][:images_attributes])
    else
      logger.error @page.errors.full_messages + params.to_s
    end

    super
  end

  def sort
    params[:paragraph].each_with_index do |id, index|
      Paragraph.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
end