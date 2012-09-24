FactoryGirl.define do
  factory :paragraph do
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:body)   { |n| "Body #{n}"}
    section "main"
    page Page.first
  end
end