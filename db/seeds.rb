# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Page.create(name: "home")
Page.create(name: "news")
u = User.create(fname: "Aaron", lname: "Richiger", email: "a.richi@bluewin.ch",
                password: "asdfasdf", password_confirmation: "asdfasdf")
u.toggle!(:admin)
u = User.create(fname: "Nicola", lname: "Roten", email: "vigu@vigu.com",
                password: "asdfasdf", password_confirmation: "asdfasdf")