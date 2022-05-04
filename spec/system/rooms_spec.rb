# frozen_string_literal: true

require 'rails_helper'

describe 'ルーム管理機能', type: :system do
  describe '詳細表示機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }

    before do
      visit room_path(room1)
    end

    it '関連づけたマップ詳細の値が参照でき、キズの説明が表示される' do
      expect(page).to have_selector '.trimming', text: '{"x":-25,"y":35}'
      expect(page).to have_selector '.expansion', text: '5'
      expect(page).to have_selector '.rotation', text: '6'
      expect(page).to have_content 'リビング、フローリン…'
    end
  end

  describe '削除機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    maps_count = 0
    marks_count = 0

    before do
      visit room_path(room1)
      maps_count = Map.all.count
      marks_count = Mark.all.count
      page.accept_confirm do
        click_link 'ルーム削除'
      end
    end

    it 'タスクが正常に削除され、関連したマップとキズも削除される' do
      expect(page).to have_selector '.alert-success', text: '削除しました'
      expect(Map.all.count).to eq maps_count - 1
      expect(Mark.all.count).to eq marks_count - 1
    end
  end
end
