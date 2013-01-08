#encoding: UTF-8

require 'spec_helper'
include SessionsHelper

describe "Home" do
  let(:home_page)  { Page.find_by_name("home") }
  let(:paragraph)  { home_page.get_paragraphs(:main).first }
  let(:caption0)  { "caption0" }

  def add_file(nr, filename)
    attach_file("paragraph_images_attributes_#{nr}_photo", Rails.root.join('spec', 'fixtures', filename))
  end

  def add_file_with_caption(nr, filename, caption)
    add_file(nr, filename)
    fill_in "paragraph_images_attributes_#{nr}_caption",  with: caption
  end

  before {
    app.default_url_options = { :locale => :de }
    visit root_path
  }

  subject { page }

  describe "Content" do
    before do
      visit edit_paragraph_path(Paragraph.first)
      fill_in "paragraph_title", with: paragraph.title
      fill_in "paragraph_body",  with: paragraph.body
      add_file_with_caption(0, 'foo.png', caption0)
      click_button t(:save)
      visit root_path
    end

    it {
      should have_content(paragraph.title)
      should have_content(paragraph.body)
      img_path = Rails.root.join('spec', 'fixtures', "foo.png")
      should have_css("img", :src => img_path)
      should have_content(caption0)
    }
  end


end
