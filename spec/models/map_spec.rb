# frozen_string_literal: true

require 'rails_helper'

describe Map, type: :model do
  describe '画像添付の検証' do
    let(:map1) { FactoryBot.create(:map) }

    before do
      map1.image = fixture_file_upload('test_image.jpg')
    end

    it '画像添付したマップが検証通過すること' do
      expect(map1).to be_valid
    end
  end
end
