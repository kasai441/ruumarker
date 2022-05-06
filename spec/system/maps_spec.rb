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
      let(:show_map) { page.find_by_id('show-map') }

      before do
        expect(uploaded[:src]).to include 'sample.png'
        attach_file 'upload-image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
      end

      it '画像が登録されてルームに遷移する' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(show_map[:src]).not_to include 'sample.png'
        expect(show_map[:src]).to include 'test_image.jpg'
        expect(page).to have_selector 'h1', text: 'キズ点検表'
        expect(Room.find(room1.id).map.image.attached?).to eq true
      end
    end

    # context '画像をアップロードして登録ボタンを押した時', js: true do
    #   before do
    #     attach_file 'upload-image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
    #     find('#submit').click
    #   end
    #
    #   it '正常にマップが登録されてルーム画面に遷移する' do
    #     expect(page).to have_content 'ルーム詳細'
    #     expect(Room.find(room1.id).map.image.attached?).to eq true
    #   end
    # end

    context '新規作成後に初期のトリミングが0x0になる' do
    end
  end

  describe '更新機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let(:show_image) { page.find_by_id('show-image') }
    let(:show_field) { page.find_by_id('show-field') }
    let(:edit_image) { page.find_by_id('edit-image') }
    let(:move_x) { 10 }
    let(:move_y) { -30 }

    before do
      visit room_path(room1)
      click_link 'マップ編集'
    end

    let!(:ex_left) { style_px_to_i(show_image, 'left') }
    let!(:ex_top) { style_px_to_i(show_image, 'top') }
    let!(:constrainRangeX) { style_px_to_i(show_field, 'width') / 3 }
    let!(:constrainRangeY) { style_px_to_i(show_field, 'height') / 3 }
    let!(:ex_upload) { page.find_by_id('show-image')[:src] }

    context '詳細画面から更新ボタンを押したとき' do
      before do
        expect(page).to have_selector '#show-image'
        find('#edit').click
        # エラー時のJSからのメッセージの表示
        # puts page.driver.browser.manage.logs.get(:browser).collect(&:message)
      end

      it '編集画面に遷移する' do
        expect(page).to have_selector '#edit-image'
      end
    end

    context '編集画面にてトリミング操作を行ったとき' do
      before do
        find('#edit').click
        page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
        find('#update').click
      end

      it 'トリミングが保存され、詳細画面で反映されている' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to eq ex_left + move_x
        expect(top).to eq ex_top + move_y
      end
    end

    context '画像をアップロードしたとき' do
      before do
        attach_file 'upload-image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')
      end

      it '画像が変更される' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(page.find_by_id('show-image')[:src]).not_to eq ex_upload
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

    context '画像をアップロードして編集を押したとき' do
      before do
        expect(show_image[:src]).to include 'jpg'
        attach_file 'upload-image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')
        find('#edit').click
      end

      it '画像が更新されている' do
        expect(page).to have_selector '#edit-image'
        edit_image = page.find_by_id('edit-image')
        expect(edit_image[:src]).to include 'png'
      end
    end

    context '画像をアップロードしてトリミングしたとき' do
      before do
        attach_file 'upload-image', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')
        find('#edit').click
        page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
        find('#update').click
      end

      it '更新内容が反映される' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to eq ex_left + move_x
        expect(top).to eq ex_top + move_y
      end
    end

    context '画面編集時に上限以上のトリミングを行ったとき' do
      before do
        find('#edit').click
        page.driver.browser.action.drag_and_drop_by(edit_image.native, constrainRangeX + 10,
                                                    constrainRangeY + 10).perform
        find('#update').click
      end

      it '上限のトリミング幅となる' do
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to eq constrainRangeX
        expect(top).to eq constrainRangeY
      end
    end

    context '画面編集時に下限以下のトリミングを行ったとき' do
      before do
        find('#edit').click
        page.driver.browser.action.drag_and_drop_by(edit_image.native, -constrainRangeX - 10,
                                                    -constrainRangeY - 10).perform
        find('#update').click
      end

      it '下限のトリミング幅となる' do
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to eq(-constrainRangeX)
        expect(top).to eq(-constrainRangeY)
      end
    end
  end
end
