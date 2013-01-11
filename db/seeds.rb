# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

include ApplicationHelper


home_page = Page.create(name: "home")
news_page = Page.create(name: "news")
partners_page = Page.create(name: "partners")
about_page = Page.create(name: "about")

########################## Home, News #########################################

[home_page, news_page].each do |page|
  paragraph_collection = ParagraphCollection.create(page: page,
                                                    section: "main",
                                                    picture_mode: :any,
                                                    has_date: true,
                                                    has_caption: true)

  3.times do |nr|
    p = Paragraph.create(paragraph_collection: paragraph_collection, date: Date.today)

    [:de, :en, :es].each do |locale|
      I18n.backend.store_translations(locale, {p.get_title_tag => "#{page.name.capitalize} #{nr}"})
      I18n.backend.store_translations(locale, {p.get_body_tag => lorem(300)})
    end
  end

end

########################## Parnters ###########################################

paragraph_collection = ParagraphCollection.create(page: partners_page,
                                                  section: "main",
                                                  picture_mode: :at_most_one,
                                                  has_date: false,
                                                  has_caption: false)

3.times do |nr|
  p = Paragraph.create(paragraph_collection: paragraph_collection, date: Date.today)

  [:de, :en, :es].each do |locale|
    I18n.backend.store_translations(locale, {p.get_title_tag => "#{partners_page.name.capitalize} #{nr}"})
    I18n.backend.store_translations(locale, {p.get_body_tag => lorem(300)})
  end
end


########################## About us ###########################################

[:de, :en, :es].each do |locale|
  I18n.backend.store_translations(locale, {:about_page_title => "About us"})
  I18n.backend.store_translations(locale, {:about_people_title => "Persons"})
  I18n.backend.store_translations(locale, {:about_work_title => "How we work"})
  I18n.backend.store_translations(locale, {:about_contact_title => "Contact"})
end

I18n.backend.store_translations(I18n.default_locale, {:contact_email_address => "nicola.roten@vision-guatemala.org"})

about_people_paragraph_collection = ParagraphCollection.create(page: about_page,
                                                               section: "people",
                                                               picture_mode: :at_most_one,
                                                               has_date: false,
                                                               has_caption: false)
p_nicola = Paragraph.create(paragraph_collection: about_people_paragraph_collection,
                            date: Date.today)

[:de, :en, :es].each do |locale|
  I18n.backend.store_translations(locale, {p_nicola.get_title_tag => "Nicola Roten"})
  I18n.backend.store_translations(locale, {p_nicola.get_body_tag => "From Switzerland."})
end

p_cesar = Paragraph.create(paragraph_collection: about_people_paragraph_collection,
                           date: Date.today)

[:de, :en, :es].each do |locale|
  I18n.backend.store_translations(locale, {p_cesar.get_title_tag => "Cesar"})
  I18n.backend.store_translations(locale, {p_cesar.get_body_tag => "From Guatemala."})
end



about_work_paragraph_collection = ParagraphCollection.create(page: about_page,
                                                             section: "work",
                                                             picture_mode: :any,
                                                             has_date: false,
                                                             has_caption: true)
p_credits = Paragraph.create(paragraph_collection: about_work_paragraph_collection,
                             date: Date.today)

[:de, :en, :es].each do |locale|
  I18n.backend.store_translations(locale, {p_credits.get_title_tag => "Micro finance"})
  I18n.backend.store_translations(locale, {p_credits.get_body_tag => "Over 100 women participated on this project."})
end

p_education = Paragraph.create(paragraph_collection: about_work_paragraph_collection,
                               date: Date.today)

[:de, :en, :es].each do |locale|
  I18n.backend.store_translations(locale, {p_education.get_title_tag => "Education"})
  I18n.backend.store_translations(locale, {p_education.get_body_tag => "The children of our women get educated."})
end


########################## Users ##############################################

u = User.create(fname: "Aaron", lname: "Richiger", email: "a.richi@bluewin.ch",
                password: "asdfasdf", password_confirmation: "asdfasdf")

u.toggle!(:admin)
u = User.create(fname: "Nicola", lname: "Roten", email: "vigu@vigu.com",
                password: "asdfasdf", password_confirmation: "asdfasdf")