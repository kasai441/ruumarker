# frozen_string_literal: true

FactoryBot.define do
  factory :mark do
    description { 'リビング、フローリングに削れ' }
    location { '{"x":0,"y":0}' }
    trimming { '{"x":0,"y":0}' }
    after(:build) do |item|
      file_name = 'test_image.jpg'
      file_path = Rails.root.join('spec', 'fixtures', 'files', file_name)
      item.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
    end
    map
  end
end
