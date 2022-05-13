# frozen_string_literal: true

require 'rails_helper'

describe 'ルーム管理機能', type: :system do
  describe '新規作成機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let(:preview) { page.find_by_id('preview-image') }

    before do
      visit root_path
    end

    context '「キズ点検表を作る」ボタンを押したとき' do
      let!(:ex_rooms_count) { Room.all.count }

      before do
        find('#create-room').click
      end

      it 'ルームが作成されてマップアップロード画面に遷移する' do
        expect(Room.all.count).to eq ex_rooms_count + 1
        expect(page).to have_selector '#preview-image'
        expect(preview[:src]).to include 'sample.png'
        expect(page).to have_selector 'h1', text: '間取り画像のアップロード'
      end
    end

    describe '表示機能' do
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
  end

  describe '削除機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let!(:ex_maps_count) { Map.all.count }
    let!(:ex_marks_count) { Mark.all.count }

    before do
      visit room_path(room1)
      page.accept_confirm do
        click_link 'ルーム削除'
      end
    end

    it 'タスクが正常に削除され、関連したマップとキズも削除される' do
      expect(page).to have_selector '.alert-success', text: '削除しました'
      expect(Map.all.count).to eq ex_maps_count - 1
      expect(Mark.all.count).to eq ex_marks_count - 1 #roomに帰属するマークの数に直す ex_をつける
    end
  end
end
