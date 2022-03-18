# frozen_string_literal: true

require 'rails_helper'

describe 'マップ管理機能', type: :system do
  describe '新規作成機能' do
    let(:room1) { FactoryBot.create(:room) }

    before do
      visit new_room_map_path(room1)
    end

    context '画像をアップロードしたとき' do
      before do
        attach_file 'image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
      end

      it '画像と編集ボタンと登録ボタンが表示される' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(page).to have_selector '.image img'
        expect(page).to have_selector '.btn', text: '編集'
        expect(page).to have_selector '.btn', text: '登録'
      end
    end

    context '画像をアップロードして登録ボタンを押した時', js: true do
      before do
        attach_file 'image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        find('#submit').click
      end

      it '正常にマップが登録されてルーム画面に遷移する' do
        expect(page).to have_content 'ルーム詳細'
        expect(Room.find(room1.id).map.image.attached?).to eq true
      end
    end

    context '画像をアップロードして編集ボタンを押した時' do
      before do
        attach_file 'image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        find('#edit').click
      end

      it '正常にマップが登録されて編集画面に遷移する' do
        expect(page).to have_content 'マップ画像を編集します'
        expect(Room.find(room1.id).map.image.attached?).to eq true
      end
    end
  end

  describe '更新機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
      click_link 'マップ編集'
    end

    context '値を変更したとき' do
      before do
        fill_in 'Trimming', with: '1, 2'
        click_button '更新する'
      end

      it '値が反映される' do
        expect(page).to have_selector '.alert-success', text: '変更しました'
        expect(page).to have_selector '.trimming', text: '1, 2'
        expect(page).to have_selector '.image img'
        expect(page).to have_content 'ルーム詳細'
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      before do
        attach_file 'map_image', Rails.root.join('spec', 'fixtures', 'files', 'test_zip.zip')
        click_button '更新する'
      end

      it '更新を失敗して編集画面にもどされる' do
        expect(page).to have_selector '#error_explanation', text: 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
        expect(page).to have_content 'マップ画像を編集します'
      end
    end
  end
end
