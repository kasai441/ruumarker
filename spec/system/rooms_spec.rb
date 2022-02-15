# frozen_string_literal: true

require 'rails_helper'

describe 'ルーム管理機能', type: :system do
  describe '詳細表示機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
    end

    it 'ルーム詳細画面で、関連づけたマップ詳細の値を参照できる' do
      expect(page).to have_selector '.trimming', text: '1, 2, 3, 4'
      expect(page).to have_selector '.expansion', text: '5'
      expect(page).to have_selector '.rotation', text: '6'
      expect(page).to have_selector '.image img'
    end
  end

  describe 'ルーム削除機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
      page.accept_confirm do
        click_link 'ルーム削除'
      end
    end

    it 'タスクが正常に削除される' do
      expect(page).to have_selector '.alert-success', text: '削除しました'
    end
  end
end
