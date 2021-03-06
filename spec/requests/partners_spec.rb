require 'spec_helper'
require 'support/paragraph_spec_helpers.rb'
include ApplicationHelper
include ParagraphSpecHelper

describe PartnersController do
  let(:corresponding_page)  { Page.find_by_name("partners") }
  let(:section)  { "main" }
  let(:paragraph_html_tag)  { "paragraph" }
  let(:updated_paragraph)  { get_test_paragraph(corresponding_page, section) }
  let(:original_paragraph)  { corresponding_page.get_paragraphs(:main).first }

  subject { page }

  before do
    set_default_locale_for_tests
    login_user(FactoryGirl.create(:admin))
  end

  describe "in admin mode when" do

    describe "adding a new partner" do
      it {
        expect { visit new_admin_partner_path }.to(
                              change(Paragraph, :count).by(1) &&
                              change(Translation, :count).by(6))
      }
    end

    describe "editing an existing partner" do
      let(:editable)  { true }
      before { visit edit_admin_partner_path(original_paragraph) }
      check_edit_paragraph
    end

    describe "deleting an article" do
      before { visit admin_partners_path }
      check_delete_paragraph
    end
  end



  describe "not in admin mode when" do

    describe "showing all partners" do
      let(:editable)  { false }

      before do
        visit edit_admin_partner_path(original_paragraph)
        change_everything_and_save
        visit partners_path
      end

      it {
        check_everything_except_date
      }

    end
  end
end