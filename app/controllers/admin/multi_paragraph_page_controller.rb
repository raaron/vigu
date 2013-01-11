class Admin::MultiParagraphPageController < Admin::PageController

  def update

    page_params = params[@page.class.name.downcase]

    # Hack: Updating paragraphs fails for some strange reasons if their date
    # did not change. Updating paragraphs with date changes works as expected.
    # To allow updates in all cases, we first make an update to an impossible
    # date and then make an update to the real date.


    # Define a date, that will never occure in the params, but will be used for the fake update.
    impossible_date = Date.new(1990, 1, 1)

    # Setup the fake params for the first fake update (Change the date fields of
    # all paragraphs to an impossible date).
    fake_params = page_params.deep_dup
    collection_params = fake_params[:paragraph_collections_attributes]

    collection_params.keys.each do |collection_key|
      paragraph_params = collection_params[collection_key][:paragraphs_attributes]

      paragraph_params.keys.each do |paragraph_key|
        paragraph_id = paragraph_params[paragraph_key][:id]

        paragraph_params.delete(paragraph_key)
        fake_date_hash = get_date_hash(impossible_date)
        fake_date_hash[:id] = paragraph_id
        paragraph_params[paragraph_key] = fake_date_hash

        # Additionally, add key/values for the original date to the
        # page_params, if they are not already there anyways.
        # This is necesarry in case of missing date values in the params hash.
        original_date = Paragraph.find(paragraph_id).date
        original_hash = get_date_hash(original_date)
        page_params[:paragraph_collections_attributes][collection_key][:paragraphs_attributes][paragraph_key].update(original_hash)
      end
    end

    # Perform the fake update.
    @page.update_attributes(fake_params)

    # Finally do the real update with the original params.
    if @page.update_attributes(page_params)
      page_params[:paragraph_collections_attributes].keys.each do |collection_key|
        update_caption_translation(page_params[:paragraph_collections_attributes][collection_key][:paragraphs_attributes].values)
        flash.notice = "Updated successfully"
        logger.debug "* Updated: #{@page.to_s}"
        logger.debug page_params
      end
    else
      puts "ERROR WHEN UPDATING ATTRIBUTES"
      logger.debug @page.errors.full_messages
      flash.notice = @page.errors.full_messages
    end

    # Finally, check, whether the pressed submit button was a "Add Link" button
    if params[:add_link]
      link_text = " link(#{t(:visible_text)}, #{t(:invisible_url)}) "
      p = Paragraph.find(params[:add_link].keys.first)
      p.update_attributes({title: p.get_title, body: p.get_body + link_text})
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

  private
  # Get a rails-style params hash for +date+.
  def get_date_hash(date)
    {
      "date(1i)" => date.year.to_s,
      "date(2i)" => date.month.to_s,
      "date(3i)" => date.day.to_s
    }
  end
end