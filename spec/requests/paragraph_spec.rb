require 'spec_helper'
require 'support/paragraph_spec_helpers.rb'
include ParagraphSpecHelper
include ApplicationHelper

describe Paragraph do
  let(:corresponding_page)  { Page.find_by_name("home") }
  let(:section)  { "main" }
  let(:paragraph_html_tag)  { "paragraph" }
  let(:reference_paragraph)  { get_test_paragraph(corresponding_page, section) }
  let(:edited_paragraph)  { corresponding_page.paragraphs.first }

  subject { page }

  before { app.default_url_options = { :locale => :de } }

  describe "Index page to show all paragraphs" do
    let(:existing_paragraph)  { corresponding_page.paragraphs.first }

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
    it {
      expect { visit new_paragraph_path }.to(
                              change(Paragraph, :count).by(1) &&
                              change(Translation, :count).by(6))

    }
  end

  describe "Edit an existing paragraph" do
    let(:editable)  { true }

    before { visit edit_paragraph_path(edited_paragraph) }
    check_edit_paragraph
  end

  describe "Delete paragraph" do
    before { visit paragraphs_path }
    check_delete_paragraph
  end

  describe "Show a paragraph" do
    let(:editable)  { false }

    before do
      visit edit_paragraph_path(edited_paragraph)
      change_everything_and_save
      visit paragraph_path(edited_paragraph)
    end

    it {
      check_everything_except_date
      check_visibility(l(reference_paragraph.date))
    }

  end
end
