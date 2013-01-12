require 'spec_helper'
include ApplicationHelper

describe HomeController do

  def check_content
    should have_content(t(:home).capitalize)
    should have_content(t(:home_page_title))
    should have_content(t(:home_people_title))
    should have_content(t(:home_work_title))
    should have_content(t(:home_contact_title))
  end

  subject {page}
  before { login_user(FactoryGirl.create(:user)) }

  describe "in default locale" do

    before do
      set_default_locale_for_tests
      visit home_path
    end

    it { check_content }

  end

  describe "not in default locale" do

    before do
      set_non_default_locale_for_tests
      visit home_path
    end

    it {
      check_content
    }

  end

end