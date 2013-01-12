require 'spec_helper'
include ApplicationHelper

describe Home do

  before do
    @home_page = Home.new(name: "home")
  end

  subject { @home_page }

  it { should respond_to(:page_title) }
  it { should respond_to(:people_title) }
  it { should respond_to(:work_title) }
  it { should respond_to(:contact_title) }

  describe "when updating the page content" do

    before { @home_page.save }

    describe "update translations automatically" do
      let(:new_page_title)  { "new page title" }
      let(:new_people_title)  { "new people title" }
      let(:new_work_title)  { "new work title" }
      let(:new_contact_title)  { "new contact title" }

      def update_and_save_page_content
        @home_page.page_title = new_page_title
        @home_page.people_title = new_people_title
        @home_page.work_title = new_work_title
        @home_page.contact_title = new_contact_title
      end

      def check_page_content
        expect { @home_page.save }.to(change(Translation, :count).by(0))

        t(:home_page_title).should == new_page_title
        t(:home_people_title).should == new_people_title
        t(:home_work_title).should == new_work_title
        t(:home_contact_title).should == new_contact_title
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
