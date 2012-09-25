#encoding: UTF-8

require 'spec_helper'

describe "Home" do
  let(:home_page)  { FactoryGirl.create(:page, name: 'home') }
  let(:paragraph)  { FactoryGirl.create(:paragraph, page: home_page) }
  let(:caption0)  { "caption0" }

  def add_file(nr, filename)
    attach_file("paragraph_images_attributes_#{nr}_photo", Rails.root.join('spec', 'img', filename))
  end

  def add_file_with_caption(nr, filename, caption)
    add_file(nr, filename)
    fill_in "paragraph_images_attributes_#{nr}_caption",  with: caption
  end

  before {
    app.default_url_options = { :locale => :de }
    home_page.save
    paragraph.save
    visit root_path
  }

  subject { page }

  it { should have_content('Vision Guatemala') }

  describe "Header" do
    it { should have_content('Deutsch') }
  end

  describe "Footer" do
    it { should have_content('Languages') }
  end

  describe "Navigation" do

    it {
      should have_link('Home', href: root_path)
      should have_link('Administration', href: admin_path)
      should have_link('Übersetzung', href: translations_path)
      should have_link('News', href: news_path)
      should have_link('Registrieren', href: register_path)
      should have_link('Roadmap', href: development_roadmap_path)
      should have_link("TODO's", href: development_todo_path)
      should have_link('Done', href: development_done_path)
    }

  end

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
      img_path = Rails.root.join('spec', 'img', "foo.png")
      should have_css("img", :src => img_path)
      should have_content(caption0)
    }
  end

  describe "Internationalization" do

    def check_german_link
      should have_link('Deutsch', href: "/de")
    end

    def check_english_link
      should have_link('English', href: "/en")
    end

    def check_spanish_link
      should have_link('Espanol', href: "/es")
    end

    it "Check correct automatically determined language" do
      should have_content('Deutsch')
    end

    it {
      visit "/de"
      should have_content('Deutsch')
      check_english_link
      check_spanish_link
    }

    it {
      visit "/es"
      should have_content('Espanol')
      check_english_link
      check_german_link
    }

    it {
      visit "/en"
      should have_content('English')
      check_german_link
      check_spanish_link
    }
  end
end
