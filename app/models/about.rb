class About < Page
  include ApplicationHelper

  attr_accessible :page_title, :people_title, :work_title,
                  :contact_title, :contact_email_address
  attr_accessor :page_title, :people_title, :work_title,
                :contact_title, :contact_email_address

  after_save :update_translation

  def update_translation
    update_translations(I18n.locale, {:about_page_title => page_title})
    update_translations(I18n.locale, {:about_people_title => people_title})
    update_translations(I18n.locale, {:about_work_title => work_title})
    update_translations(I18n.locale, {:about_contact_title => contact_title})
    update_translations(I18n.default_locale,
                          {:contact_email_address => contact_email_address})
  end
end
