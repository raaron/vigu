FactoryGirl.define do
  factory :paragraph do
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:body)   { |n| "Body #{n}"}
    section "main"
    page Page.first
  end
end

FactoryGirl.define do
  factory :user do
    fname    "Aaron"
    lname    "Richiger"
    email    "aaron@example.com"
    admin    true
    password "asdfasdf"
    password_confirmation "asdfasdf"
  end
end

FactoryGirl.define do
  factory :page do
    name        "home"
    paragraphs  []
  end
end
