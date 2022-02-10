# frozen_string_literal: true

FactoryBot.define do
  factory :map do
    trimming { '30, 40, 10, 10' }
    expansion { '88' }
    rotation { '2' }
    room
  end
end
