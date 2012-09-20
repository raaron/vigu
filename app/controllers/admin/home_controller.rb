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
    p.insert_empty_translations

    redirect_to admin_path
  end

  def update
    if @page.update_attributes(params[:page])
      flash.notice = "Updated successfully"
      logger.debug "* Updated: #{@page.to_s}"
    else
      logger.debug @page.errors.full_messages
      # flash.notice = @page.errors.full_messages
    end

    @page.paragraphs.each do |paragraph|
      paragraph.update_translation
    end

    redirect_to admin_path
  end

end
