# frozen_string_literal: true

require 'rails_helper'

describe Map, type: :model do
  describe '画像添付の検証' do
    let(:map1) { FactoryBot.create(:map) }

    context '画像添付されているとき' do
      before do
        map1.image = fixture_file_upload('test_image.jpg')
      end

      it '検証通過すること' do
        expect(map1).to be_valid
      end
    end

    context '画像添付されていないとき' do
      before do
        map1.image = nil
      end

      it '検証で失敗すること' do
        expect(map1).to_not be_valid
      end
    end
  end
end
