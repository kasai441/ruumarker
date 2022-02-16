# frozen_string_literal: true

require 'rails_helper'

describe Room, type: :model do
  let(:room1) { FactoryBot.create(:room) }

  describe 'set_id' do
    it '20桁のIDを生成する' do
      expect(room1.id.size).to eq 20
    end
  end
end
