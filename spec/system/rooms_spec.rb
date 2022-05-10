# frozen_string_literal: true

require 'rails_helper'

describe 'ルーム管理機能', type: :system do
  describe '詳細表示機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let(:show_image) { page.find_by_id('show-image') }

    context 'ルームにアクセスするとき' do
      before do
        visit room_path(room1)
      end

      it 'ルーム詳細画面に遷移し、マップ画像が表示され、キズの説明が表示される' do
        expect(page).to have_selector 'h1', text: 'キズ点検表'
        expect(show_image[:src]).to include 'test_image.jpg'
        expect(page).to have_content 'リビング、フローリン…'
      end
    end

    context 'タイトルをクリックするとき' do
      before do
        visit room_path(room1)
        find('#title-logo').click
      end

      it 'ルーム詳細画面に遷移し、マップ画像が表示される' do
        expect(page).to have_selector 'h1', text: 'キズ点検表'
        expect(show_image[:src]).to include 'test_image.jpg'
      end
    end

    context '2回タイトルをクリックするとき' do
      before do
        visit room_path(room1)
        find('#title-logo').click
        find('#title-logo').click
      end

      it 'ルーム詳細画面に遷移し、マップ画像が表示される' do
        expect(page).to have_selector 'h1', text: 'キズ点検表'
        expect(show_image[:src]).to include 'test_image.jpg'
      end
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
