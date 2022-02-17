# frozen_string_literal: true

FactoryBot.define do
  factory :mark do
    description { 'MyText' }
    location { 'MyString' }
    trimming { 'MyString' }
    expansion { 'MyString' }
    rotation { 'MyString' }
  end
end