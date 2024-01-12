# spec/factories.rb

FactoryBot.define do
  factory(:user) do
    email { Faker::Internet.unique.email }
  end

  factory(:candidate) do
    name { Faker::Name.unique.name }
  end

  factory(:vote) do
    user
    candidate
  end
end
