require 'spec_helper'
require 'support/paragraph_spec_helpers.rb'
include ParagraphSpecHelper
include ApplicationHelper

describe Paragraph do
  let(:home_page)  { Page.find_by_name("home") }
  let(:caption0)  { "caption0" }
  let(:caption1)  { "caption1" }
  let(:new_caption0)  { "new caption0" }
  let(:reference_paragraph)  { get_test_paragraph(home_page) }

  subject { page }

  before { app.default_url_options = { :locale => :de } }

  describe "Index page to show all paragraphs" do
    let(:existing_paragraph)  { home_page.paragraphs.first }

    before { visit paragraphs_path }

    it {
      should have_content('Paragraphs')
      should have_content('ID:')
      should have_link(t_add(:paragraph), href: new_paragraph_path)
      should have_link('Show', href: paragraph_path(existing_paragraph))
      should have_link('Edit', href: edit_paragraph_path(existing_paragraph))
      should have_link('Destroy', href: paragraph_path(existing_paragraph))
    }
  end

  describe "New paragraph" do

    before do
      visit new_paragraph_path
      should have_content(t(:body))

      fill_in_paragraph_form_with_date("paragraph", reference_paragraph)
    end

    after do
      current_path.should == edit_paragraph_path(home_page.paragraphs.last)
      check_paragraph_form_with_date("paragraph", reference_paragraph)
    end

    describe "Without picture" do

      it {
        check_translation_change_on_button_click(t(:save), 1, 6)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        check_paragraph(new_paragraph, reference_paragraph)
        new_paragraph.images.count.should == 0
      }
    end

    describe "With picture without caption" do

      before { add_file(0, 'foo.png') }

      it {
        check_translation_change_on_button_click(t(:save), 1, 9)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        check_paragraph(new_paragraph, reference_paragraph)
        new_paragraph.images.count.should == 1
      }
    end

    describe "With picture and caption" do

      before { add_file_with_caption(0, 'foo.png', caption0) }

      it {
        check_translation_change_on_button_click(t(:save), 1, 9)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        check_paragraph(new_paragraph, reference_paragraph)
        new_paragraph.images.count.should == 1
        check_caption(new_paragraph, 0, caption0)
        should have_selector("input", :value => caption0)
      }
    end

    describe "With multiple pictures" do

      before { add_file_with_caption(0, 'foo.png', caption0) }

      it {
        check_translation_change_on_button_click(t(:save), 1, 9)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        check_paragraph(new_paragraph, reference_paragraph)
        add_file_with_caption(1, 'bar.png', caption1)
        check_translation_change_on_button_click(t(:save), 1, 3)
        new_paragraph.images.count.should == 2
        check_caption(new_paragraph, 0, caption0)
        check_caption(new_paragraph, 1, caption1)
      }
    end
  end

  describe "Edit paragraph" do

    before do
      visit paragraphs_path
      visit edit_paragraph_path(home_page.paragraphs.first)
      add_file_with_caption(0, 'foo.png', caption0)
      click_button t(:save)
      fill_in_paragraph_form_with_date("paragraph", reference_paragraph)
      fill_in "paragraph_images_attributes_0_caption",  with: new_caption0
    end

    after do
      current_path.should == edit_paragraph_path(home_page.paragraphs.first)
      check_paragraph_form_with_date("paragraph", reference_paragraph)
    end

    describe "Edit title, body and caption" do
      it {
        check_translation_change_on_button_click(t(:save), 0, 0)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        new_paragraph.images.count.should == 1
        check_caption(new_paragraph, 0, new_caption0)
      }
    end

    describe "Add picture" do
      it {
        add_file_with_caption(1, 'bar.png', caption1)
        check_translation_change_on_button_click(t(:save), 1, 3)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        new_paragraph.images.count.should == 2
        check_caption(new_paragraph, 0, new_caption0)
        check_caption(new_paragraph, 1, caption1)
      }
    end

    describe "Delete picture" do
      it {
        check ('paragraph_images_attributes_0__destroy')
        check_translation_change_on_button_click(t(:save), 0, -3)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        new_paragraph.images.count.should == 0
      }
    end

    describe "Delete multiple pictures" do
      it {
        add_file_with_caption(1, 'bar.png', caption1)
        check_translation_change_on_button_click(t(:save), 1, 3)
        check ('paragraph_images_attributes_0__destroy')
        check ('paragraph_images_attributes_1__destroy')
        check_translation_change_on_button_click(t(:save), 0, -6)
        new_paragraph = Paragraph.find_by_date(reference_paragraph.date)
        new_paragraph.images.count.should == 0
      }
    end
  end

  describe "Delete paragraph" do

    before do
      visit edit_paragraph_path(home_page.paragraphs.first)
      add_file_with_caption(0, 'foo.png', caption0)
      click_button t(:save)
      visit paragraphs_path
    end

    it {
      old_paragraph_count = Paragraph.count
      old_translation_count = Translation.count
      path = paragraph_path(home_page.paragraphs.first)
      expect { page.driver.submit(:delete, path, {}) }.to(
                                          change(Paragraph, :count).by(-1) &&
                                          change(Translation, :count).by(-9))

      current_path.should == paragraphs_path
      should have_link(t_add(:paragraph), href: new_paragraph_path)
      Paragraph.count.should == old_paragraph_count - 1
      Translation.count.should == old_translation_count - 9
    }

  end

  describe "Show paragraph" do

    before do
      p = home_page.paragraphs.first
      visit edit_paragraph_path(p)
      fill_in_paragraph_form_with_date("paragraph", reference_paragraph)
      add_file_with_caption(0, 'foo.png', caption0)
      click_button t(:save)
      visit paragraph_path(p)
    end

    it {
      should have_content(reference_paragraph.title)
      should have_content(reference_paragraph.body)
      img_path = Rails.root.join('spec', 'fixtures', "foo.png")
      should have_css("img", :src => img_path)
      should have_content(caption0)
    }

  end
end
