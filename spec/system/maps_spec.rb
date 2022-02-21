# frozen_string_literal: true

require 'rails_helper'

describe 'マップ管理機能', type: :system do
  describe '新規作成機能' do
    before do
      visit new_room_path
      fill_in 'Trimming', with: '10, 20'
      fill_in 'Expansion', with: '30'
      fill_in 'Rotation', with: '40'
    end

    context '画像をアップロードしたとき' do
      before do
        attach_file 'map_image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        click_button '登録する'
      end

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(page).to have_selector '.trimming', text: '10, 20'
        expect(page).to have_selector '.expansion', text: '30'
        expect(page).to have_selector '.rotation', text: '40'
        expect(page).to have_selector '.image img'
      end
    end

    context '画像をアップロードしないとき' do
      before do
        click_button '登録する'
      end

      it '登録に失敗して作成画面にもどる' do
        expect(page).to have_selector '#error_explanation', text: 'マップの画像が必要です'
        expect(page).to have_content 'マップの画像を登録してください'
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      before do
        attach_file 'map_image', Rails.root.join('spec', 'fixtures', 'files', 'test_zip.zip')
        click_button '登録する'
      end

      it '登録に失敗して作成画面にもどる' do
        expect(page).to have_selector '#error_explanation', text: 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
        expect(page).to have_content 'マップの画像を登録してください'
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
        expect(page).to have_content 'マップ画像を変更します'
      end
    end
  end
end
