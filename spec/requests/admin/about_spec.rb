require 'spec_helper'
include ApplicationHelper

def check_content
  should have_content(t(:about_us).capitalize)
  should have_content(t(:about_page_title))
  should have_content(t(:about_people_title))
  should have_content(t(:about_work_title))
  should have_content(t(:about_contact_title))
  should have_content(t_for_default_locale(:contact_email_address))
end

def check_translations_on_save
  expect { click_button t(:save) }.to(change(Translation, :count).by(0))
end

def update_page_content
  fill_in "about_page_title",             with: updated_about_page.page_title
  fill_in "about_people_title",           with: updated_about_page.people_title
  fill_in "about_work_title",             with: updated_about_page.work_title
  fill_in "about_contact_title",          with: updated_about_page.contact_title
  fill_in "about_contact_email_address",  with: updated_about_page.contact_email_address
end

def check_page(reference_page, disabled)
  if disabled
    disabled_tag = "disabled_"
  else
    disabled_tag = ""
  end

  find_field("about_#{disabled_tag}page_title").value.should == reference_page.page_title
  find_field("about_#{disabled_tag}people_title").value.should == reference_page.people_title
  find_field("about_#{disabled_tag}work_title").value.should == reference_page.work_title
  find_field("about_#{disabled_tag}contact_title").value.should == reference_page.contact_title
  find_field("about_contact_email_address").value.should == updated_about_page.contact_email_address

  should_not have_css("input#about_disabled_contact_email_address")
end

def check_non_default_language_content_invisible
  should_not have_css("input#about_disabled_page_title")
  should_not have_css("input#about_disabled_people_title")
  should_not have_css("input#about_disabled_work_title")
  should_not have_css("input#about_disabled_contact_title")
end




describe Admin::AboutController do

  let(:original_about_page)  { FactoryGirl.create(:original_about_page) }
  let(:updated_about_page)  { FactoryGirl.create(:updated_about_page) }

  subject {page}

  before { login_user(FactoryGirl.create(:admin)) }

  describe "in admin mode" do

    let(:new_page_title)  { "new page title" }
    let(:new_people_title)  { "new people title" }
    let(:new_work_title)  { "new work title" }
    let(:new_contact_title)  { "new contact title" }
    let(:new_contact_email_address)  { "new contact email address" }

    before { set_is_in_admin_mode(true) }

    describe "not in default locale" do
      before do
        set_non_default_locale_for_tests
        visit admin_about_path
        update_page_content
      end

      it {
        check_translations_on_save
        check_page(updated_about_page, disabled=false)
        check_page(original_about_page, disabled=true)
      }
    end

    describe "in default locale" do
      before do
        set_default_locale_for_tests
        visit admin_about_path
        update_page_content
      end

      it {
        check_translations_on_save
        check_page(updated_about_page, disabled=false)
        check_non_default_language_content_invisible
      }
    end
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