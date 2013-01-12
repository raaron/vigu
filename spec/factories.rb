# FactoryGirl.define do
#   factory :image do
#     caption       "new caption"
#     photo         File.open(Rails.root.join('spec', 'fixtures', "foo.png"))
#     association   :paragraph
#   end
# end

# FactoryGirl.define do
#   factory :paragraph do |p|
#     id                    1000
#     title                 "new title"
#     body                  "new body"
#     paragraph_collection  Page.first.paragraph_collections.first
#     date                  Date.new(2012, 1, 31)
#   end
# end

# Factory.define :paragraph_with_image, :parent => :paragraph do |p|
#   p.id      1001
#   p.images  { |g| [g.association(:image)]}
# end

FactoryGirl.define do
  factory :user do
    sequence(:fname)        { |n| "Person Fname #{n}" }
    sequence(:lname)        { |n| "Person Lname #{n}" }
    sequence(:email)        { |n| "person_#{n}@example.com"}
    password                "asdfasdf"
    password_confirmation   "asdfasdf"

    factory :admin do
      admin true
    end

  end
end

FactoryGirl.define do
  factory :page do
    name        "home"
    paragraph_collections  []
  end
end

FactoryGirl.define do
  factory :about do
    factory :original_about_page do
      page_title              I18n.translate(:about_page_title)
      people_title            I18n.translate(:about_people_title)
      work_title              I18n.translate(:about_work_title)
      contact_title           I18n.translate(:about_contact_title)
      contact_email_address   I18n.translate(:contact_email_address)
    end

    factory :updated_about_page do
      page_title              "new page title"
      people_title            "new people title"
      work_title              "new work title"
      contact_title           "new contact title"
      contact_email_address   "new@email.address"
    end

  end
end


FactoryGirl.define do
  factory :home do
    factory :original_home_page do
      page_title              I18n.translate(:home_page_title)
      people_title            I18n.translate(:home_people_title)
      work_title              I18n.translate(:home_work_title)
      contact_title           I18n.translate(:home_contact_title)
    end

    factory :updated_home_page do
      page_title              "new page title"
      people_title            "new people title"
      work_title              "new work title"
      contact_title           "new contact title"
    end

  end
end
