module MultiParagraphPageSpecHelper

  def check_admin_mode
    before { set_is_in_admin_mode(true) }

    describe "not in default locale" do
      check_locale(is_default=false)
    end

    describe "in default locale" do
      check_locale(is_default=true)
    end
  end

  def check_locale(is_default)
    before do
      is_default ? set_default_locale_for_tests : set_non_default_locale_for_tests
      visit admin_view_path
    end

    describe "when updating the page content" do
      check_update_page_content
    end

    (0 .. SECTIONS.count - 1).each do |paragraph_collection_index|
      describe "when editing the paragraph" do
        let(:section) { SECTIONS[paragraph_collection_index] }
        let(:paragraph_collection) { ParagraphCollection.find(:first, :conditions => ["page_id = ? and section = ?", corresponding_page, section]) }
        check_add_paragraph
        check_update_paragraph("#{HTML_TAG_PREFIX}#{paragraph_collection_index}#{HTML_TAG_POSTFIX}")
      end
    end
  end

  def check_update_page_content
    before { update_page_content }

    it {
      check_translation_change_on_button_click(t(:save), 0, 0)
      check_page(updated_page, disabled=false)
      if is_default_locale
        check_non_default_language_content_invisible
      else
        check_page(original_page, disabled=true)
      end
    }
  end


  def check_update_paragraph(html_tag)
    let(:paragraph_html_tag) { html_tag }
    let(:original_paragraph) { corresponding_page.get_paragraphs(section)[0] }
    let(:updated_paragraph)  { get_test_paragraph(corresponding_page, section) }

    describe "when editing title, body, date and first image" do
      before do
        change_everything_and_save
      end

      it {
        check_input_value_for_paragraph("title", updated_paragraph.title, disabled=false)
        check_input_value_for_paragraph("body", updated_paragraph.body, disabled=false)

        if is_default_locale
          check_image_visible(0)
          check_input_for_paragraph_invisible("title")
          check_input_for_paragraph_invisible("body")
        else
          check_input_value_for_paragraph("title", original_paragraph.get_default_title, disabled=true)
          check_input_value_for_paragraph("body", original_paragraph.get_default_body, disabled=true)
        end
      }
    end

    describe "when pressing add_link" do
      let!(:link_text) { original_paragraph.get_body + " link(#{t(:visible_text)}, #{t(:invisible_url)}) " }
      it {
        click_button("add_link[#{original_paragraph.id}]")
        check_input_value_for_paragraph("body", link_text, disabled=false)
      }
    end
  end

  def check_add_paragraph
    let(:button_id) { "add_paragraph[#{paragraph_collection.id}]" }
    it { check_translation_change_on_button_click(button_id, 1, 6) }
  end

  def check_input_value(input_tag, solution, disabled)
    disabled_tag = disabled ? "disabled_" : ""
    find_field("#{corresponding_page.name}_#{disabled_tag}#{input_tag}").value.strip.should == solution.strip
  end

  def check_input_invisible(tag, disabled=true)
    disabled_tag = disabled ? "disabled_" : ""
    should_not have_css("input##{corresponding_page.name}_#{disabled_tag}#{tag}")
  end

  def check_input_value_for_paragraph(input_tag, solution, disabled)
    disabled_tag = disabled ? "disabled_" : ""
    find_field("#{paragraph_html_tag}_#{disabled_tag}#{input_tag}").value.strip.should == solution.strip
  end

  def check_input_for_paragraph_invisible(tag, disabled=true)
    disabled_tag = disabled ? "disabled_" : ""
    should_not have_css("input##{paragraph_html_tag}_#{disabled_tag}title")
  end
end





