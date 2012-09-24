#encoding: UTF-8

require 'spec_helper'

describe "Home" do

  before { visit root_path }

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
      should have_link('Home', href: get_url(root_path))
      should have_link('Administration', href: get_url(admin_path))
      should have_link('Übersetzung', href: get_url(translations_path))
      should have_link('Roadmap', href: get_url(development_roadmap_path))
      should have_link("TODO's", href: get_url(development_todo_path))
      should have_link('Done', href: get_url(development_done_path))
    }

  end

  describe "Content" do

    it { should have_content('Home Title') }
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
