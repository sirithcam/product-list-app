FactoryBot.define do
  factory :product do
    name { 'Test Product' }
    price  { 20 }
    description { 'Lorem ipsum' }
    tags { [] }
  end
end

FactoryBot.define do
  factory :tag do
    title { 'test_tag' }
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
