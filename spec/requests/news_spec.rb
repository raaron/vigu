require 'spec_helper'
require 'support/paragraph_spec_helpers.rb'
include ApplicationHelper
include ParagraphSpecHelper

describe "News" do
  let(:corresponding_page)  { Page.find_by_name("news") }
  let(:section)  { "main" }
  let(:paragraph_html_tag)  { "paragraph" }
  let(:reference_paragraph)  { get_test_paragraph(corresponding_page, section) }
  let(:edited_paragraph)  { corresponding_page.paragraphs.first }

  subject { page }

  before do
    app.default_url_options = { :locale => :de }
    login_user(FactoryGirl.create(:admin))
  end

  describe "in admin mode when" do

    describe "adding a new article" do
      it {
        expect { visit new_admin_news_path }.to(
                              change(Paragraph, :count).by(1) &&
                              change(Translation, :count).by(6))
      }
    end

    describe "editing an existing article" do
      let(:editable)  { true }
      before { visit edit_admin_news_path(edited_paragraph) }
      check_edit_paragraph
    end

    describe "deleting an article" do
      before { visit admin_news_index_path }
      check_delete_paragraph
    end
  end



  describe "not in admin mode when" do

    describe "showing all articles" do
      let(:editable)  { false }

      before do
        visit edit_admin_news_path(edited_paragraph)
        change_everything_and_save
        visit news_path
      end

      it {
        check_everything_except_date
        check_visibility(l(reference_paragraph.date))
      }

    end
  end
end