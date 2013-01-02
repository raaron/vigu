require 'spec_helper'
include ApplicationHelper

describe "Authentication" do
  let(:home_page)  { Page.find_by_name("home") }

  before { app.default_url_options = { :locale => :de } }

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Login') }
    it { should have_selector('title', text: 'Login') }

    describe "with invalid information" do
      before { click_button "Login" }

      it { should have_selector('title', text: 'Login') }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        login_user(user)
      end

      it { should have_selector('title', text: user.fname) }

      it { should have_link('Profile', href: edit_user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }


      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end

  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          login_user(user)
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Login') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Login') }
        end
      end
    end


    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { login_user(user) }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(login_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { login_user non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(login_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { login_user admin }

      describe "in admin mode (editing content)" do
        before { visit admin_news_path }

        it {
          should have_selector(
            'a',
            content: t(:normal_view),
            href: admin_switch_to_normal_view_path,
            admin_view_path: news_path)
        }
      end

      describe "not in admin mode (viewing content)" do
        before {
          set_is_in_admin_mode(false)
          visit admin_news_path
        }

        it {
          should have_selector(
            'a',
            content: t(:admin_view),
            href: admin_switch_to_admin_view_path,
            admin_view_path: admin_news_path)
        }
      end
    end

  end
end
