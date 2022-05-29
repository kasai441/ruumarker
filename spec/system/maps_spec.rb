# frozen_string_literal: true

require 'rails_helper'
require 'support/dom_helper'

describe 'マップ管理機能', type: :system do
  include DomHelper

  describe '新規作成機能' do
    let(:show_image) { page.find_by_id('show-image') }
    let(:preview) { page.find_by_id('preview-image') }

    before do
      visit new_room_path
    end

    context '画像をアップロードしたとき' do
      before do
        expect(preview[:src]).to include 'sample.png'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '画像が登録されてルームに遷移する' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(show_image[:src]).to include 'test_image.jpg'
        expect(page).to have_selector 'h2', text: 'キズ点検表'
      end
    end

    context '画像をアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '初期のトリミングが0x0になる' do
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to eq 0
        expect(top).to eq 0
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'not_image.jpg'), make_visible: true
      end

      it '画像が変化しない' do
        # expect(page).to have_selector '#error_explanation', text: 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
        expect(preview[:src]).to include 'sample.png'
        expect(page).to have_selector '#preview-image'
      end
    end

    context '制約幅以下の画像ファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '画像幅が元のままとなる' do
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        expect(execute_script('return arguments[0].naturalWidth', show_image)).to eq 88
      end
    end

    context '制約幅以上の画像ファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'large_image.jpg'), make_visible: true
      end

      it '画像が制約幅になる' do
        max = 500
        # debugger
        # 実行方法 RSPEC_DEBUG=true be rspec
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        expect(execute_script('return arguments[0].naturalWidth', show_image)).to eq max
      end
    end
  end

  describe '更新機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let(:show_image) { page.find_by_id('show-image') }
    let(:show_field) { page.find_by_id('show-field') }
    let(:edit_image) { page.find_by_id('edit-image') }

    before do
      visit room_path(room1)
    end

    let!(:ex_left) { style_px_to_i(show_image, 'left') }
    let!(:ex_top) { style_px_to_i(show_image, 'top') }
    let!(:show_field_width) { style_px_to_i(show_field, 'width') }
    let!(:show_field_height) { style_px_to_i(show_field, 'height') }
    let!(:constrainRangeX) { show_field_width / 4 }
    let!(:constrainRangeY) { show_field_height / 4 }
    let(:move_x) { show_field_width / 5 }
    let(:move_y) { show_field_height / 5 }

    before do
      find_by_id('image-edit').click
    end

    context '編集画面にてトリミング操作を行ったとき' do
      before do
        page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
        find_by_id('update').click
      end

      it 'トリミングが保存され、詳細画面で反映されている' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to be_within(2).of(ex_left + move_x)
        expect(top).to be_within(2).of(ex_top + move_y)
      end
    end

    context '画像をアップロードしたとき' do
      before do
        expect(page.find_by_id('edit-image')[:src]).to include 'test_image.jpg'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
      end

      it '画像が変更される' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(page.find_by_id('edit-image')[:src]).not_to include 'test_image.jpg'
        expect(page.find_by_id('edit-image')[:src]).to include 'data:image/png'
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'not_image.jpg'), make_visible: true
      end

      it '更新を失敗して画面がそのまま遷移しない' do
        # expect(page).to have_selector '#error_explanation', text: 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
        expect(page).to have_selector '#edit-image'
      end
    end

    context '画像をアップロードして変更を押したとき' do
      before do
        expect(edit_image[:src]).to include 'test_image.jpg'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
        find_by_id('update').click
      end

      it '画像が更新されている' do
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        expect(show_image[:src]).to include 'test_image.png'
      end
    end

    context '画像をアップロードしてトリミングしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
        page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
        find_by_id('update').click
      end

      it '更新内容が反映される' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to be_within(2).of(ex_left + move_x)
        expect(top).to be_within(2).of(ex_top + move_y)
      end
    end

    context '画面編集時に上限以上のトリミングを行ったとき' do
      before do
        page.driver.browser.action.drag_and_drop_by(edit_image.native, constrainRangeX + 10,
                                                    constrainRangeY + 10).perform
        find_by_id('update').click
      end

      it '上限のトリミング幅となる' do
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to be_within(2).of(constrainRangeX)
        expect(top).to be_within(2).of(constrainRangeY)
      end
    end

    context '画面編集時に下限以下のトリミングを行ったとき' do
      before do
        page.driver.browser.action.drag_and_drop_by(edit_image.native, -constrainRangeX - 10,
                                                    -constrainRangeY - 10).perform
        find_by_id('update').click
      end

      it '下限のトリミング幅となる' do
        expect(page).to have_selector '#show-image'
        show_image = page.find_by_id('show-image')
        left = style_px_to_i(show_image, 'left')
        top = style_px_to_i(show_image, 'top')
        expect(left).to be_within(2).of(-constrainRangeX)
        expect(top).to be_within(2).of(-constrainRangeY)
      end
    end
  end
end
