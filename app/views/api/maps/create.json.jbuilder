# frozen_string_literal: true

json.merge! @map.attributes
json.image_url url_for(@map.image)
