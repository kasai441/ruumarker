# frozen_string_literal: true

require 'rails_helper'

describe 'ルーム管理機能', type: :system do
  describe '詳細表示機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) do
      FactoryBot.create(:map,
                        trimming: '100, 200',
                        expansion: '300',
                        rotation: '400',
                        room: room1)
    end

    before do
      visit room_path(room1)
    end

    it 'ルーム詳細画面で、関連づけたマップ詳細の値を参照できる' do
      expect(page).to have_selector '.trimming', text: '100, 200'
      expect(page).to have_selector '.expansion', text: '300'
      expect(page).to have_selector '.rotation', text: '400'
    end
  end
end
