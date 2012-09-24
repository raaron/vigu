require 'spec_helper'
include ApplicationHelper

describe "Paragraph" do

  subject { page }

  before {
    @page = Page.new(name: "home")
    @page.save
  }

  describe "Index page to show all paragraphs" do
    it {
      visit paragraphs_path
      should have_content('Paragraphs')
    }
  end

  describe "New paragraph" do
    let(:paragraph)  { FactoryGirl.build(:paragraph, page: @page) }

    describe "Valid without picture" do

      before do
        visit new_paragraph_path
        should have_content('Beschreibung')
        fill_in "paragraph_title", with: paragraph.title
        fill_in "paragraph_body",  with: paragraph.body

      end

      it {
        expect { click_button t(:save) }.to change(Paragraph, :count).by(1) && change(Translation, :count).by(2)
        p = Paragraph.first
        p.page.should == @page
        p.section.should == paragraph.section
        t(p.get_title_tag).should == paragraph.title
        t(p.get_body_tag).should == paragraph.body
      }
    end

    describe "Valid with picture" do

      before do
        visit new_paragraph_path
        should have_content('Beschreibung')
        fill_in "paragraph_title", with: paragraph.title
        fill_in "paragraph_body",  with: paragraph.body
        attach_file("paragraph_images_attributes_0_photo", Rails.root.join('spec', 'img', 'test.png'))

      end

      it {
        expect { click_button t_add(:caption) }.to change(Paragraph, :count).by(1) && change(Translation, :count).by(5)
        fill_in "paragraph_body",  with: paragraph.body

        # expect { click_button t(:save) }.to change(Paragraph, :count).by(1) && change(Translation, :count).by(5)
        p = Paragraph.first
        p.page.should == @page
        p.section.should == paragraph.section
        t(p.get_title_tag).should == paragraph.title
        t(p.get_body_tag).should == paragraph.body
      }
    end
  end


end
