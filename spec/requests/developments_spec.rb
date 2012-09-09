require 'spec_helper'

describe "Development" do
  describe "Home page" do

    it "should have the content 'Vision Guatemala'" do
      visit '/development/home'
      page.should have_content('Vision Guatemala')
    end

    it "should display german text as default" do
      visit '/development/home'
      page.should have_content('Deutsch')
    end

    it "should display german text for german users" do
      ENV['HTTP_ACCEPT_LANGUAGE'] = 'de'
      visit '/development/home'
      page.should have_content('Deutsch')
    end

    it "should display spanish text for spanish users" do
      ENV['HTTP_ACCEPT_LANGUAGE'] = 'es-gt'
      visit '/development/home'
      page.should have_content('Espanol')
    end

    it "should display english text for english users" do
      ENV['HTTP_ACCEPT_LANGUAGE'] = 'en'
      visit '/development/home'
      page.should have_content('English')
    end

  end
end
