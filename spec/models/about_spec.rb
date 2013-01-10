require 'spec_helper'
include ApplicationHelper

describe About do

  before do
    @about_page = About.new(name: "about")
  end

  subject { @about_page }

  it { should respond_to(:page_title) }
  it { should respond_to(:people_title) }
  it { should respond_to(:work_title) }
  it { should respond_to(:contact_title) }
  it { should respond_to(:contact_email_address) }

  describe "when updating the page content" do

    before { @about_page.save }

    describe "update translations automatically" do
      let(:new_page_title)  { "new page title" }
      let(:new_people_title)  { "new people title" }
      let(:new_work_title)  { "new work title" }
      let(:new_contact_title)  { "new contact title" }
      let(:new_contact_email_address)  { "new contact email address" }

      def update_and_save_page_content
        @about_page.page_title = new_page_title
        @about_page.people_title = new_people_title
        @about_page.work_title = new_work_title
        @about_page.contact_title = new_contact_title
        @about_page.contact_email_address = new_contact_email_address
      end

      def check_page_content
        expect { @about_page.save }.to(change(Translation, :count).by(0))

        t(:about_page_title).should == new_page_title
        t(:about_people_title).should == new_people_title
        t(:about_work_title).should == new_work_title
        t(:about_contact_title).should == new_contact_title
        t_for_default_locale(:contact_email_address).should == new_contact_email_address
      end

      describe "when in default locale" do

        before do
          I18n.locale = I18n.default_locale
          update_and_save_page_content
        end

        it { check_page_content }

      end

      describe "when not in default locale" do

        before do
          I18n.locale = :de
          update_and_save_page_content
        end

        it { check_page_content }

      end
    end
  end
end
