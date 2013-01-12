#encoding: UTF-8

require 'spec_helper'


describe "General page template" do

  before {
    set_non_default_locale_for_tests
    visit root_path
  }

  subject { page }

  describe "Title" do
    it { should have_content('Vision Guatemala') }
  end

  describe "Header" do
    it { should have_content('Deutsch') }
  end

  describe "Footer" do
    it { should have_content('Languages') }
  end

  describe "Navigation" do
    let(:non_admin_user)  { FactoryGirl.create(:user) }
    let(:admin_user)  { FactoryGirl.create(:admin) }
    let(:have_link_checker) { lambda {|text, url| should have_link(text, href: url)} }
    let(:not_have_link_checker) { lambda {|text, url| should_not have_link(text, href: url)} }

    def check_always_visible_links
      should have_link(t(:translations), href: translations_path)
      should have_link('Roadmap', href: development_roadmap_path)
      should have_link("TODO's", href: development_todo_path)
      should have_link('Done', href: development_done_path)
    end

    def check_link(checker, text, url)
      checker.call(text, url)
    end

    have_link_checker = lambda {|text, url| should have_link(text, href: url)}
    not_have_link_checker = lambda {|text, url| should_not have_link(text, href: url)}

    def check_admin_links(is_admin)
      visible_as_admin = is_admin ? have_link_checker : not_have_link_checker
      invisible_as_admin = is_admin ? not_have_link_checker : have_link_checker

      check_link(visible_as_admin, t(:news), admin_news_index_path)
      check_link(visible_as_admin, t(:partners), admin_partners_path)
      check_link(visible_as_admin, t(:about_us), admin_about_path)
      check_link(visible_as_admin, t(:home), admin_home_path)
      check_link(visible_as_admin, t(:users), users_path)
      check_link(visible_as_admin, t(:admin), admin_path)

      check_link(invisible_as_admin, t(:news), news_path)
      check_link(invisible_as_admin, t(:partners), partners_path)
      check_link(invisible_as_admin, t(:about_us), about_path)
      check_link(invisible_as_admin, t(:home), home_path)
    end

    def check_logged_in_links(is_logged_in, user=nil)
      have_link_checker = lambda {|text, url| should have_link(text, href: url)}
      not_have_link_checker = lambda {|text, url| should_not have_link(text, href: url)}

      visible_if_logged_in = is_logged_in ? have_link_checker : not_have_link_checker
      invisible_if_logged_in = is_logged_in ? not_have_link_checker : have_link_checker

      check_link(visible_if_logged_in, t(:logout).capitalize, logout_path)
      if user.nil?
        should_not have_link(t(:profile).capitalize)
      else
        should have_link(t(:profile).capitalize, hfref: edit_user_path(user))
      end
      check_link(invisible_if_logged_in, t(:register).capitalize, register_path)
      check_link(invisible_if_logged_in, t(:login).capitalize, login_path)
    end

    describe "if not logged in" do
      it {
        check_always_visible_links
        check_logged_in_links(false)
        check_admin_links(false)
      }
    end

    describe "if logged in as non admin user" do
      before { login_user(non_admin_user) }
      it {
        check_always_visible_links
        check_logged_in_links(true, non_admin_user) # since the profile link is not visible anyways, we can pass any user to check
        check_admin_links(false)
      }
    end

    describe "if logged in as admin user" do
      before { login_user(admin_user) }
      it {
        check_always_visible_links
        check_logged_in_links(true, admin_user)
        check_admin_links(true)
      }
    end
  end

  describe "Internationalization" do

    def check_german_link
      should have_link('Deutsch', href: "/de")
    end

    def check_english_link
      should have_link('English', href: "/en")
    end

    def check_spanish_link
      should have_link('Espanol', href: "/es")
    end

    it "Check correct automatically determined language" do
      should have_content('Deutsch')
    end

    it {
      set_locale_for_tests(:de)
      visit root_path
      should have_content('Deutsch')
      check_english_link
      check_spanish_link
    }

    it {
      set_locale_for_tests(:es)
      visit root_path
      should have_content('Espanol')
      check_english_link
      check_german_link
    }

    it {
      set_locale_for_tests(:en)
      visit root_path
      check_german_link
      check_spanish_link
    }
  end
end
