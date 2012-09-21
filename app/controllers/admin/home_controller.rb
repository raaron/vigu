class Admin::HomeController < ApplicationController

  def initialize
    @page = Page.find_by_name('home')
    super
  end

  def show
  end

  def new_paragraph
    p = Paragraph.new(page: @page, section: 'main', title: "", body: "")
    logger.debug "* Inserted new: #{p.to_s}"
    @page.paragraphs = [] unless @page.paragraphs
    @page.paragraphs << p
    p.insert_empty_translation

    redirect_to admin_path
  end

  def update
    if @page.update_attributes(params[:page])
      @page.paragraphs.each do |paragraph|
        paragraph.update_translation
      end
      update_caption_translation(params[:page][:paragraphs_attributes].values)
      flash.notice = "Updated successfully"
      logger.debug "* Updated: #{@page.to_s}"
      logger.debug params[:page][:paragraphs_attributes]["0"][:images_attributes]["0"][:caption]
    else
      logger.debug @page.errors.full_messages
      flash.notice = @page.errors.full_messages
    end

    redirect_to admin_path
  end

  private
  def update_caption_translation(pars)
    pars.each do |par|
      if par[:_destroy].to_i < 1
        p = Paragraph.find(par[:id])
        p.update_caption_translation(par[:images_attributes])
      end
    end
  end

end
