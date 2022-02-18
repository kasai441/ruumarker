# frozen_string_literal: true

class ImageValidator < ActiveModel::EachValidator
  FILE_SIZE = 10
  VALID_TYPES = %w[jpg jpeg png gif].freeze
  def validate_each(record, attribute, _value)
    return unless record.image.attached?

    record.errors.add attribute, :file_too_large, count: FILE_SIZE if record.image.blob.byte_size > FILE_SIZE.megabytes

    return if VALID_TYPES.map { |v| "image/#{v}" }.include?(record.image.blob.content_type)

    record.errors.add attribute, :file_type_not_image, types: VALID_TYPES.join('/')
  end
end
