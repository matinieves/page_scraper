FactoryGirl.define do
  factory :page do
    url "http://www.google.com"
  end

  # This will use the User class (Admin would have been guessed)
  factory :page_element do
    element_type "h1"
    content 'lorem ipsum'
    page
  end
end
