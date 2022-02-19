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
        file_path = Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        attach_file 'map_image', file_path
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
        within '#error_explanation' do
          expect(page).to have_content 'マップの画像が必要です'
        end
        expect(page).to have_content 'マップの画像を登録してください'
      end
    end

    context '画像の代わりにzipファイルをアップロードしたとき' do
      before do
        file_path = Rails.root.join('spec', 'fixtures', 'files', 'test_zip.zip')
        attach_file 'map_image', file_path
        click_button '登録する'
      end

      it '登録に失敗して作成画面にもどる' do
        within '#error_explanation' do
          expect(page).to have_content 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
        end
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
      fill_in 'Trimming', with: '1, 2'
      fill_in 'Expansion', with: '3'
      fill_in 'Rotation', with: '4'
      attach_file 'map_image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
      click_button '更新する'
    end

    context 'すべてのパラメーターが検証どおりのとき' do
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '変更しました'
        expect(page).to have_selector '.trimming', text: '1, 2'
        expect(page).to have_selector '.expansion', text: '3'
        expect(page).to have_selector '.rotation', text: '4'
        expect(page).to have_selector '.image img'
      end
    end

    context '検証が失敗した時' do
      # あとで（検証失敗していない）
      it '編集画面にもどされる' do
        expect(page).to have_content 'マップ画像を変更します'
      end
    end
  end
end
