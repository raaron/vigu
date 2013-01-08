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

[home_page, news_page, partners_page].each do |page|
  paragraph_collection = ParagraphCollection.create(page: page, section: "main")

  3.times do |nr|
    p = Paragraph.create(paragraph_collection: paragraph_collection, date: Date.today)

    [:de, :en, :es].each do |locale|
      I18n.backend.store_translations(locale, {p.get_title_tag => "#{page.name.capitalize} #{nr}"})
      I18n.backend.store_translations(locale, {p.get_body_tag => lorem(300)})
    end
  end

end

u = User.create(fname: "Aaron", lname: "Richiger", email: "a.richi@bluewin.ch",
                password: "asdfasdf", password_confirmation: "asdfasdf")

u.toggle!(:admin)
u = User.create(fname: "Nicola", lname: "Roten", email: "vigu@vigu.com",
                password: "asdfasdf", password_confirmation: "asdfasdf")