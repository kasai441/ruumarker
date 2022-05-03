# frozen_string_literal: true

require 'rails_helper'
require 'support/dom_helper'

describe 'マップ管理機能', type: :system do
  include DomHelper

  describe '新規作成機能' do
    let(:room1) { FactoryBot.create(:room) }

    before do
      visit new_room_map_path(room1)
    end

    context '画像をアップロードしたとき' do
      let(:uploaded) { page.find_by_id('uploaded') }

      before do
        expect(uploaded[:src].split('/')).to include 'sample.png'
        attach_file 'image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
      end


      it '画像と登録ボタンが表示される' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(uploaded[:src].split('/')).not_to include 'sample.png'
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
  end

  describe '更新機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
      click_link 'マップ編集'
    end

    let(:show_image) { page.find_by_id('show-image') }
    let!(:ex_left) { style_value_of(show_image[:style], 'left') }
    let!(:ex_top) { style_value_of(show_image[:style], 'top') }

    context '編集画面にてトリミング操作を行ったとき' do
      let(:edit_image) { page.find_by_id('edit-image') }
      let(:move_x) { 10 }
      let(:move_y) { -30 }

      before do
        find('#edit').click
        page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
        find('#update').click
      end

      it 'トリミングが保存され、詳細画面で反映されている' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_value_of(show_image[:style], 'left')
        top = style_value_of(show_image[:style], 'top')

        expect(left).to eq ex_left + move_x
        expect(top).to eq ex_top + move_y
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      # before do
      #   attach_file 'image', Rails.root.join('spec', 'fixtures', 'files', 'test_zip.zip')
      #   find('#submit').click
      # end
      #
      # it '更新を失敗して編集画面にもどされる' do
      #   expect(page).to have_selector '#error_explanation', text: 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
      #   expect(page).to have_content '間取り図を編集します'
      # end
    end
  end
end
