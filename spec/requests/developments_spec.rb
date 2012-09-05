require 'spec_helper'

describe "Development" do
  describe "Home page" do
    it "should have the content 'Vision Guatemala'" do
      visit '/development/home'
      page.should have_content('Vision Guatemala')
    end
  end
end
