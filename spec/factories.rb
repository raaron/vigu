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
