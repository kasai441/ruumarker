# frozen_string_literal: true

FactoryBot.define do
  factory :map do
    trimming { '{"x":0,"y":0}' }
    expansion { 100 }
    rotation { 0 }
    after(:build) do |item|
      file_name = 'test_image.jpg'
      file_path = Rails.root.join('spec', 'fixtures', 'files', file_name)
      item.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
    end
    room
  end
end
