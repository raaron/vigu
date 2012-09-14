require 'spec_helper'

describe "Development" do

  subject { page }
  describe "Home page" do

    it {
      visit root_path
      should have_content('Vision Guatemala')
    }

    it {
      visit root_path
      should have_content('Deutsch')
    }

    it {
      ENV['HTTP_ACCEPT_LANGUAGE'] = 'de'
      visit root_path
      should have_content('Deutsch')
    }

    it {
      ENV['HTTP_ACCEPT_LANGUAGE'] = 'es-gt'
      visit root_path
      should have_content('Espanol')
    }

    it {
      ENV['HTTP_ACCEPT_LANGUAGE'] = 'en'
      visit root_path
      should have_content('English')
    }

  end
end
