class Admin::PageController < Admin::ApplicationController

  before_filter :admin_user

  def new_paragraph
    p = Paragraph.new(page: @page, section: 'main', title: "", body: "", date: Date.today)
    logger.debug "* Inserted new: #{p.to_s}"
    @page.paragraphs = [] unless @page.paragraphs
    @page.paragraphs << p
    p.insert_empty_translation

    redirect_to request.referrer
  end

  def update

    # Hack: Updating paragraphs fails for some strange reasons if their date
    # did not change. Updating paragraphs with date changes works as expected.
    # To allow updates in all cases, we first make an update to an impossible
    # date and then make an update to the real date.


    # Define a year, that will never occure in the params, but will be used for the fake update.
    impossible_year = "1999"

    # Setup the fake params for the first fake update (Change the date fields of
    # all paragraphs to an impossible date).
    fake_params = params[:page].deep_dup
    par_attrs = fake_params[:paragraphs_attributes]
    par_attrs.keys.each do |key|
      par_attrs[key]["date(1i)"] = impossible_year
    end

    # Perform the fake update.
    @page.update_attributes(fake_params)

    # p = {"paragraphs_attributes"=>{"3"=>{"title"=>"new title", "date(3i)"=>"2", "date(2i)"=>"1", "date(1i)"=>"2013", "id"=>"7"}}}

    # Finally do the real update with the original params.
    if @page.update_attributes(params[:page])
      update_caption_translation(params[:page][:paragraphs_attributes].values)
      flash.notice = "Updated successfully"
      logger.debug "* Updated: #{@page.to_s}"
      logger.debug params[:page]
    else
      puts "ERROR WHEN UPDATING ATTRIBUTES"
      logger.debug @page.errors.full_messages
      flash.notice = @page.errors.full_messages
    end

    redirect_to request.referrer
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
