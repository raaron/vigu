require 'spec_helper'
require 'support/paragraph_spec_helpers.rb'
include ApplicationHelper
include ParagraphSpecHelper

def check_edited_paragraph_without_date
  check_translation_change_on_button_click(t(:save), 0, 0)
  edited_paragraph = Paragraph.find_by_id(edited_paragraph_id)
  check_paragraph(edited_paragraph, reference_paragraph)
  edited_paragraph.images.count.should == 0
  check_paragraph_form_without_date(edited_paragraph_html_tag, reference_paragraph)
end

describe "News" do
  let(:news_page)  { Page.find_by_name("news") }
  let(:caption0)  { "caption0" }
  let(:caption1)  { "caption1" }
  let(:new_caption0)  { "new caption0" }
  let(:new_caption1)  { "new caption1" }
  let(:reference_paragraph)  { get_test_paragraph(news_page) }

  subject { page }

  before do
    app.default_url_options = { :locale => :de }
    login_user(FactoryGirl.create(:admin))
    visit admin_news_path
  end

  after do
    current_path.should == admin_news_path
    should have_content(t(:body))
    should have_button(t_add(:paragraph))
  end

  describe "New paragraph" do

    it {
      old_paragraph_count = news_page.paragraphs.count
      check_translation_change_on_button_click("#{t_add(:paragraph)}", 1, 6)
      news_page.paragraphs.count.should == old_paragraph_count + 1
    }
  end

  describe "Edit an existing paragraph" do

    let(:edited_paragraph_id)  { 6 }
    let(:edited_paragraph_html_tag)  { "page_paragraphs_attributes_2" }

    describe "title and body only" do

      before do
        fill_in_paragraph_form_without_date(edited_paragraph_html_tag, reference_paragraph)
      end

      it { check_edited_paragraph_without_date }
    end


    describe "title, body and date only" do

      before do
        fill_in_paragraph_form_with_date(edited_paragraph_html_tag, reference_paragraph)
      end

      it {
        check_edited_paragraph_without_date
        check_paragraph_form_with_date(edited_paragraph_html_tag, reference_paragraph)
      }
    end
  end

  describe "Delete paragraph" do

    it {
      path = paragraph_path(news_page.paragraphs.first)
      expect { page.driver.submit(:delete, path, {}) }.to(
                                          change(Paragraph, :count).by(-1) &&
                                          change(Translation, :count).by(-6))
    }
  end
end