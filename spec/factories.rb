# spec/factories.rb

FactoryBot.define do
  factory(:user) do
    email { Faker::Internet.email }
  end

  factory(:candidate) do
    name { Faker::Name }
  end

  factory(:vote) do
    user
    candidate
  end
end
