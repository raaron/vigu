require 'spec_helper'

describe "User pages" do
  let(:home_page)  { FactoryGirl.create(:page, name: 'home') }

  before {
    app.default_url_options = { :locale => :de }
    home_page.save
  }

  subject { page }

  describe "index" do
    before do
      login FactoryGirl.create(:user)
      FactoryGirl.create(:user, fname: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, fname: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.fname)
      end
    end
  end

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
    before {
      login(user)
      visit edit_user_path(user)
    }

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Speichern" }

      # it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_fname)  { "New fname" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Fname",            with: new_fname
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Speichern"
      end

      it { should have_selector('title', text: new_fname) }
      it { should have_link('Logout', href: logout_path) }
      specify { user.reload.fname.should  == new_fname }
      specify { user.reload.email.should == new_email }
    end
  end

end
