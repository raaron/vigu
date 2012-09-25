require 'spec_helper'

describe "User pages" do
  let(:home_page)  { FactoryGirl.create(:page, name: 'home') }

  before {
    app.default_url_options = { :locale => :de }
    home_page.save
  }

  subject { page }

  describe "register page" do
    before { visit register_path }

    it { should have_selector('h1',    text: 'Register') }
    it { should have_selector('title',    text: 'Registrieren') }


    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Registrieren" }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Fname",        with: "Example"
        fill_in "Lname",        with: "User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        check ('Admin')
      end

      it "should create a user" do
        expect { click_button "Registrieren" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Registrieren" }
        let(:user) { User.find_by_email('user@example.com') }
        it { should have_selector('title', text: user.fname) }
        it { should have_link('Logout') }
      end

    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.fname + user.lname) }
    it { should have_selector('title', text: user.fname) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Speichern" }

      # it { should have_content('error') }
    end
  end

end
