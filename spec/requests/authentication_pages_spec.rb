require 'spec_helper'

describe "Authentication" do
  let(:home_page)  { FactoryGirl.create(:page, name: 'home') }

  before {
    app.default_url_options = { :locale => :de }
    home_page.save
  }

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
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Login"
      end

      it { should have_selector('title', text: user.fname) }

      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }


      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end

  end
end
