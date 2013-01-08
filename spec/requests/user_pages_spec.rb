require 'spec_helper'

describe "User pages" do
  let(:home_page)  { Page.find_by_name("home") }

  before { app.default_url_options = { :locale => :de } }

  subject { page }

  describe "index" do
    before do
      login_user FactoryGirl.create(:user)
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

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          login_user admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
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
        fill_in t(:fname),        with: "Example"
        fill_in t(:lname),        with: "User"
        fill_in t(:email),        with: "user@example.com"
        fill_in t(:password),     with: "foobar"
        fill_in t(:password_confirmation), with: "foobar"
      end

      it "should create a user" do
        expect { click_button "Registrieren" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Registrieren" }
        let(:user) { User.find_by_email('user@example.com') }
        it { should have_selector('title', text: user.fname) }
        it { should have_link(t(:logout).capitalize, href: logout_path) }
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
      login_user(user)
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

        fill_in t(:fname),                    with: new_fname
        fill_in t(:email),                    with: new_email
        fill_in t(:password),                 with: user.password
        fill_in t(:password_confirmation),    with: user.password_confirmation
        click_button t(:save)
      end

      it { should have_selector('title', text: new_fname) }
      it { should have_link(t(:logout).capitalize, href: logout_path) }
      specify { user.reload.fname.should  == new_fname }
      specify { user.reload.email.should == new_email }
    end
  end

end
