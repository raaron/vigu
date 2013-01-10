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

describe AboutController do
  subject {page}
  before { login_user(FactoryGirl.create(:user)) }

  describe "in default locale" do

    before do
      set_default_locale_for_tests
      visit about_path
    end

    it { check_content }

  end

  describe "not in default locale" do

    before do
      set_non_default_locale_for_tests
      visit about_path
    end

    it {
      check_content
    }

  end

end