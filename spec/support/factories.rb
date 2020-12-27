FactoryBot.define do
  factory :product do
    name { generate(:name) }
    price  { 20 }
    description { 'Lorem ipsum' }
    tags { [] }
  end
end

FactoryBot.define do
  factory :tag do
    title { generate(:title) }
    products { [] }
  end
end

FactoryBot.define do
  sequence :name do |n|
    "Test Product ##{n}"
  end
end

FactoryBot.define do
  sequence :title do |n|
    "test_tag#{n}"
  end
end
