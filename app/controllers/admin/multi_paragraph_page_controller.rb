class Admin::MultiParagraphPageController < Admin::PageController

  def update

    page_params = params[:page]

    # Hack: Updating paragraphs fails for some strange reasons if their date
    # did not change. Updating paragraphs with date changes works as expected.
    # To allow updates in all cases, we first make an update to an impossible
    # date and then make an update to the real date.


    # Define a date, that will never occure in the params, but will be used for the fake update.
    impossible_date = Date.new(1999, 1, 1)

    # Setup the fake params for the first fake update (Change the date fields of
    # all paragraphs to an impossible date).
    fake_params = page_params.deep_dup
    par_attrs = fake_params[:paragraphs_attributes]
    par_attrs.keys.each do |key|
      par_attrs.delete(key)
      par_attrs[key] = {:id => page_params[:paragraphs_attributes][key][:id],
                        "date(1i)" => impossible_date.year.to_s,
                        "date(2i)" => impossible_date.month.to_s,
                        "date(3i)" => impossible_date.day.to_s
                       }
    end

    # Perform the fake update.
    @page.update_attributes(fake_params)

    # p = {"paragraphs_attributes"=>{"3"=>{"title"=>"new title", "date(3i)"=>"2", "date(2i)"=>"1", "date(1i)"=>"2013", "id"=>"7"}}}

    # Finally do the real update with the original params.
    if @page.update_attributes(page_params)
      update_caption_translation(page_params[:paragraphs_attributes].values)
      flash.notice = "Updated successfully"
      logger.debug "* Updated: #{@page.to_s}"
      logger.debug page_params
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