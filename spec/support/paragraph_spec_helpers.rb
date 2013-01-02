module ParagraphSpecHelper
  def fill_in_paragraph_form_without_date(tag, paragraph)
    fill_in tag + "_title", with: paragraph.title
    fill_in tag + "_body",  with: paragraph.body
  end

  def fill_in_paragraph_form_with_date(tag, paragraph)
    fill_in_paragraph_form_without_date(tag, paragraph)
    select_date(paragraph.date, :from => tag + "_date")
  end

  def check_paragraph_form_without_date(tag, paragraph)
    should have_selector("input", :value => paragraph.title)
    should have_content(paragraph.body)
  end

  def check_paragraph_form_with_date(tag, paragraph)
    check_paragraph_form_without_date(tag, paragraph)
    check_selected_date(paragraph.date, :from => tag + "_date")
  end

  def check_paragraph(paragraph_to_check, reference_paragraph)
    paragraph_to_check.page.should == reference_paragraph.page
    paragraph_to_check.section.should == reference_paragraph.section
    paragraph_to_check.get_title.should == reference_paragraph.title
    paragraph_to_check.get_body.should == reference_paragraph.body
  end

  def check_caption(paragraph_to_check, picture_index, caption)
    t(paragraph_to_check.images[picture_index].get_caption_tag).should == caption
  end

  def add_file(nr, filename)
    attach_file("paragraph_images_attributes_#{nr}_photo", Rails.root.join('spec', 'fixtures', filename))
  end

  def add_file_with_caption(nr, filename, caption)
    add_file(nr, filename)
    fill_in "paragraph_images_attributes_#{nr}_caption",  with: caption
  end

  def check_translation_change_on_button_click(button_name, par_change, trans_change)
    expect { click_button button_name }.to(
                              change(Paragraph, :count).by(par_change) &&
                              change(Translation, :count).by(trans_change))
  end

  def get_test_paragraph(page)
    Paragraph.new(title: "new title", body: "new body", section: "main", page: page, date: Date.new(2012, 7, 7))
  end
end