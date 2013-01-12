#encoding: UTF-8

require 'spec_helper'
include ApplicationHelper
include ParagraphSpecHelper
include MultiParagraphPageSpecHelper



describe Admin::AboutController do

  SECTIONS = ["people", "work"]
  HTML_TAG_PREFIX = "about_paragraph_collections_attributes_"
  HTML_TAG_POSTFIX = "_paragraphs_attributes_0"

  def check_content
    should have_content(t(:about_us).capitalize)
    should have_content(t(:about_page_title))
    should have_content(t(:about_people_title))
    should have_content(t(:about_work_title))
    should have_content(t(:about_contact_title))
    should have_content(t_for_default_locale(:contact_email_address))
  end

  def update_page_content
    fill_in "about_page_title",             with: updated_page.page_title
    fill_in "about_people_title",           with: updated_page.people_title
    fill_in "about_work_title",             with: updated_page.work_title
    fill_in "about_contact_title",          with: updated_page.contact_title
    fill_in "about_contact_email_address",  with: updated_page.contact_email_address
  end

  def check_page(reference_page, disabled)
    check_input_value("page_title", reference_page.page_title, disabled)
    check_input_value("people_title", reference_page.people_title, disabled)
    check_input_value("work_title", reference_page.work_title, disabled)
    check_input_value("contact_title", reference_page.contact_title, disabled)
    check_input_value("contact_email_address", updated_page.contact_email_address, disabled=false)

    check_input_invisible("contact_email_address")
  end

  def check_non_default_language_content_invisible
    check_input_invisible("page_title")
    check_input_invisible("people_title")
    check_input_invisible("work_title")
    check_input_invisible("contact_title")
  end

  ###############################################################################


  let(:admin_view_path) { admin_about_path }
  let(:corresponding_page)  { Page.find_by_name("about") }
  let(:original_page)  { FactoryGirl.create(:original_about_page) }
  let(:updated_page)  { FactoryGirl.build(:updated_about_page) }


  subject {page}

  before { login_user(FactoryGirl.create(:admin)) }

  describe "in admin mode" do
    check_admin_mode
  end

  describe "in normal mode" do
    before do
      set_default_locale_for_tests
      set_is_in_admin_mode(false)
      visit about_path
    end

    it {
      should have_link(t(:admin_view), href: admin_switch_to_admin_view_path(:admin_view_path => admin_about_path))
      check_content
    }
  end
end