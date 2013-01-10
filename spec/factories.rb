FactoryGirl.define do
  factory :paragraph do
    sequence(:id)  { |n| n }
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:body)   { |n| "Body #{n}"}
    section "main"
    page Page.first
    date Date.new(2012, 1, 31)
  end
end

FactoryGirl.define do
  factory :user do
    sequence(:fname)  { |n| "Person Fname #{n}" }
    sequence(:lname)  { |n| "Person Lname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "asdfasdf"
    password_confirmation "asdfasdf"

    factory :admin do
      admin true
    end

  end
end

FactoryGirl.define do
  factory :page do
    name        "home"
    paragraphs  []
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
