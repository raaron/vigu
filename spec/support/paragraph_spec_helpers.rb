module ParagraphSpecHelper

  def change_title
    fill_in paragraph_html_tag + "_default_title", with: reference_paragraph.title
  end

  def check_title
    edited_paragraph.get_title.should == reference_paragraph.title
    check_visibility(reference_paragraph.title)
  end

  def change_body
    fill_in paragraph_html_tag + "_default_body", with: reference_paragraph.body
  end

  def check_body
    edited_paragraph.get_body.should == reference_paragraph.body
    check_visibility(reference_paragraph.body)
  end

  def change_date
    select_date(reference_paragraph.date, :from => paragraph_html_tag + "_date")
  end

  def check_date
    edited_paragraph.date == reference_paragraph.date
    check_selected_date(reference_paragraph.date, :from => paragraph_html_tag + "_date")
  end

  def add_picture_without_caption(index)
    add_file(paragraph_html_tag, index, reference_paragraph.images[index].photo_file_name)
  end

  def add_picture_with_caption(index)
    img = reference_paragraph.images[index]
    add_file_with_caption(paragraph_html_tag, index, img.photo_file_name, img.caption)
  end

  def check_image_count(count)
    edited_paragraph.images.count.should == count
  end

  def check_caption(index)
    ref_caption = reference_paragraph.images[index].caption
    edited_paragraph.images[index].get_caption.should == ref_caption
    should have_selector("input", :value => ref_caption)
    check_visibility(ref_caption)
  end

  def check_click_save_changes_translation_count_by(count)
    check_translation_change_on_button_click(t(:save), 0, count)
    edited_paragraph.reload
  end

  def check_click_add_picture_changes_translation_count
    check_translation_change_on_button_click(t_add(:picture), 0, 3)
  end

  def change_everything_and_save
    change_title
    change_body
    change_date if edited_paragraph.has_date?
    add_picture_with_caption(0)
    check_click_save_changes_translation_count_by(3)
  end

  def check_everything_except_date
    check_title
    check_body
    check_image_count(1)
    check_image_visible(0)
  end

  def check_visibility(content)
    if editable
      should have_selector("input", :value => content)
    else
      should have_content(content)
    end
  end

  def check_image_visible(index)
    should have_css("img", :src => reference_paragraph.images[index].photo_file_name)
  end

  def check_image_not_visible(index)
    should_not have_css("img", :src => reference_paragraph.images[index].photo_file_name)
  end

  def add_file(tag, nr, filename)
    attach_file(tag + "_images_attributes_#{nr}_photo", Rails.root.join('spec', 'fixtures', filename))
  end

  def add_file_with_caption(tag, nr, filename, caption)
    add_file(tag, nr, filename)
    fill_in tag + "_images_attributes_#{nr}_default_caption",  with: caption
  end

  def check_translation_change_on_button_click(button_name, par_change, trans_change)
    expect { click_button button_name }.to(
                              change(Paragraph, :count).by(par_change) &&
                              change(Translation, :count).by(trans_change))
  end

  def get_test_paragraph(paragraphs_page, section)
    paragraph_collection = paragraphs_page.paragraph_collections.find_by_section(section)
    paragraph = Paragraph.new(title: "new title",
                              body: "new body",
                              paragraph_collection: paragraph_collection,
                              date: Date.new(2012, 7, 7))
    image0 = Image.new(paragraph: paragraph, :photo => File.new(Rails.root.join('spec', 'fixtures', 'foo.png'), 'r'), :caption => "caption0")
    image1 = Image.new(paragraph: paragraph, :photo => File.new(Rails.root.join('spec', 'fixtures', 'bar.png'), 'r'), :caption => "caption1")
    paragraph.images = [image0, image1]
    return paragraph
  end

  def check_edit_paragraph
    describe "change title" do
      before { change_title }
      it {
        check_click_save_changes_translation_count_by(0)
        check_title
      }
    end

    describe "change body" do
      before { change_body }
      it {
        check_click_save_changes_translation_count_by(0)
        check_body
      }
    end


    describe "change date" do
      before { change_date if edited_paragraph.has_date? }
      it {
        if edited_paragraph.has_date?
          check_click_save_changes_translation_count_by(0)
          check_date
        end
      }
    end

    describe "add picture without caption" do
      before { add_picture_without_caption(0) }
      it {
        check_click_save_changes_translation_count_by(3)
        check_image_count(1)
        check_image_visible(0)
      }
    end

    describe "add picture with caption" do
      before { add_picture_with_caption(0) }
      it {
        check_click_save_changes_translation_count_by(3)
        check_image_count(1)
        check_image_visible(0)
      }
    end

    describe "add multiple pictures with caption" do
      before do
        add_picture_with_caption(0)
        check_click_add_picture_changes_translation_count
        check_image_visible(0)
        add_picture_with_caption(1)
      end

      it {
        check_click_save_changes_translation_count_by(3)
        check_image_count(2)
        check_image_visible(1)
        check_caption(0)
        check_caption(1)
      }
    end

    describe "change caption" do
      let(:new_caption)  { "new_caption" }
      before do
        add_picture_with_caption(0)
        check_click_save_changes_translation_count_by(3)
        fill_in paragraph_html_tag + "_images_attributes_0_default_caption",  with: new_caption
        check_click_save_changes_translation_count_by(0)
      end

      it {
        edited_paragraph.images[0].get_caption.should == new_caption
        should have_selector("input", :value => new_caption)
      }
    end

    describe "change everything" do
      before { change_everything_and_save }
      it {
        check_everything_except_date
        check_date if edited_paragraph.has_date?
      }
    end

    describe "Delete picture" do
      before do
        add_picture_without_caption(0)
        check_click_save_changes_translation_count_by(3)
        check_image_count(1)
        check_image_visible(0)
      end

      it {
        check (paragraph_html_tag + '_images_attributes_0__destroy')
        check_click_save_changes_translation_count_by(-3)
        check_image_count(0)
        check_image_not_visible(0)
      }
    end

    describe "Delete multiple pictures" do
      before do
        add_picture_with_caption(0)
        check_click_add_picture_changes_translation_count
        check_image_visible(0)
        add_picture_with_caption(1)
        check_click_save_changes_translation_count_by(3)
        check_image_count(2)
        check_image_visible(1)
      end

      it {
        check (paragraph_html_tag + '_images_attributes_0__destroy')
        check (paragraph_html_tag + '_images_attributes_1__destroy')
        check_click_save_changes_translation_count_by(-6)
        check_image_count(0)
        check_image_not_visible(0)
        check_image_not_visible(0)
      }
    end
  end

  def check_delete_paragraph
    it {
      path = paragraph_path(corresponding_page.get_paragraphs(:main).first)
      expect { page.driver.submit(:delete, path, {}) }.to(
                                          change(Paragraph, :count).by(-1) &&
                                          change(Translation, :count).by(-6))
    }
  end
end