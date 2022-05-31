# frozen_string_literal: true

require 'rails_helper'
require 'support/dom_helper'

describe 'マップ管理機能', type: :system do
  include DomHelper

  describe '新規作成機能' do
    before do
      visit new_room_path
    end

    context '画像をアップロードしたとき' do
      before do
        preview = find_by_id('preview-image')
        expect(preview[:src]).to include 'sample.png'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '画像が登録されてルームに遷移する' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        image = find_by_id('show-image')
        expect(image[:src]).to include 'test_image.jpg'
        expect(page).to have_selector 'h2', text: 'キズ点検表'
      end
    end

    context '画像をアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '初期のトリミングが0x0になる' do
        image = find_by_id('show-image')
        left = pixel(image, 'left')
        top = pixel(image, 'top')
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
        preview = find_by_id('preview-image')
        expect(preview[:src]).to include 'sample.png'
      end
    end

    context '制約幅以下の画像ファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '画像幅が元のままとなる' do
        image = find_by_id('show-image')
        expect(execute_script('return arguments[0].naturalWidth', image)).to eq 88
      end
    end

    context '制約幅以上の画像ファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'large_image.jpg'), make_visible: true
      end

      it '画像が制約幅になる' do
        max = 500
        image = find_by_id('show-image')
        expect(execute_script('return arguments[0].naturalWidth', image)).to eq max
      end
    end
  end

  describe '更新機能' do
    let!(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
      find_by_id('image-edit').click
    end

    context '編集画面にてトリミング操作を行ったとき' do
      before do
        image = find_by_id('edit-image')
        page.driver.browser.action.drag_and_drop_by(image.native, 42, -25).perform
        find_by_id('update').click
      end

      it 'トリミングが保存され、詳細画面で反映されている' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        image = find_by_id('show-image')
        left = pixel(image, 'left')
        top = pixel(image, 'top')
        expect(left).to be_within(2).of(42)
        expect(top).to be_within(2).of(-25)
      end
    end

    context '画像をアップロードしたとき' do
      before do
        expect(find_by_id('edit-image')[:src]).to include 'test_image.jpg'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
      end

      it '画像が変更される' do
        # expect(page).to have_selector '.alert-success', text: '登録しました'
        expect(find_by_id('edit-image')[:src]).not_to include 'test_image.jpg'
        expect(find_by_id('edit-image')[:src]).to include 'data:image/png'
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
        image = find_by_id('edit-image')
        expect(image[:src]).to include 'test_image.jpg'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
        find_by_id('update').click
      end

      it '画像が更新されている' do
        image = find_by_id('show-image')
        expect(image[:src]).to include 'test_image.png'
      end
    end

    context '画像をアップロードしてトリミングしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
        image = find_by_id('edit-image')
        page.driver.browser.action.drag_and_drop_by(image.native, -27, 37).perform
        find_by_id('update').click
      end

      it '更新内容が反映される' do
        # expect(page).to have_selector '.alert-success', text: '変更しました
        image = find_by_id('show-image')
        left = pixel(image, 'left')
        top = pixel(image, 'top')
        expect(left).to be_within(2).of(-27)
        expect(top).to be_within(2).of(37)
      end
    end

    let!(:field_width) { pixel(find_by_id('edit-field'), 'width') }
    let!(:field_height) { pixel(find_by_id('edit-field'), 'height') }
    let!(:limitX) { field_width / 4 }
    let!(:limitY) { field_height / 4 }

    context '画面編集時に上限以上のトリミングを行ったとき' do
      before do
        image = find_by_id('edit-image')
        page.driver.browser.action.drag_and_drop_by(image.native, limitX + 10,
                                                    limitY + 10).perform
        find_by_id('update').click
      end

      it '上限のトリミング幅となる' do
        image = find_by_id('show-image')
        left = pixel(image, 'left')
        top = pixel(image, 'top')
        expect(left).to be_within(2).of(limitX)
        expect(top).to be_within(2).of(limitY)
      end
    end

    context '画面編集時に下限以下のトリミングを行ったとき' do
      before do
        image = find_by_id('edit-image')
        page.driver.browser.action.drag_and_drop_by(image.native, -limitX - 10,
                                                    -limitY - 10).perform
        find_by_id('update').click
      end

      it '下限のトリミング幅となる' do
        image = find_by_id('show-image')
        left = pixel(image, 'left')
        top = pixel(image, 'top')
        expect(left).to be_within(2).of(-limitX)
        expect(top).to be_within(2).of(-limitY)
      end
    end
  end

  describe '表示機能' do
    let!(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let!(:mark2) { FactoryBot.create(:mark, map: map1) }
    let!(:mark3) { FactoryBot.create(:mark, map: map1) }

    before do
      visit room_path(room1)
    end

    let!(:field_width) { pixel(find_by_id('show-field'), 'width') }
    let!(:field_height) { pixel(find_by_id('show-field'), 'height') }

    context '3つのマークをそれぞれ移動した時' do
      before do
        find_by_id("mark-#{mark3.id}").click
        image = find_by_id('edit-location-image')
        page.driver.browser.action.drag_and_drop_by(image.native, -33, -33).perform
        find_by_id('update').click

        find_by_id("mark-#{mark2.id}").click
        image = find_by_id('edit-location-image')
        page.driver.browser.action.drag_and_drop_by(image.native, 22, 22).perform
        find_by_id('update').click

        find_by_id("mark-#{mark1.id}").click
        image = find_by_id('edit-location-image')
        page.driver.browser.action.drag_and_drop_by(image.native, -11, -11).perform
        find_by_id('update').click

        find_by_id('image-edit').click
      end

      it '移動分がマップ編集画面で反映されている' do
        mark_radius = 10

        m1 = find_by_id("locator-#{mark1.id}")
        left = pixel(m1, 'left')
        top = pixel(m1, 'top')
        expect(left).to be_within(2).of(field_width / 2 - mark_radius - -11)
        expect(top).to be_within(2).of(field_height / 2 - mark_radius - -11)

        m2 = find_by_id("locator-#{mark2.id}")
        left = pixel(m2, 'left')
        top = pixel(m2, 'top')
        expect(left).to be_within(2).of(field_width / 2 - mark_radius - 22)
        expect(top).to be_within(2).of(field_height / 2 - mark_radius - 22)

        m3 = find_by_id("locator-#{mark3.id}")
        left = pixel(m3, 'left')
        top = pixel(m3, 'top')
        expect(left).to be_within(2).of(field_width / 2 - mark_radius - -33)
        expect(top).to be_within(2).of(field_height / 2 - mark_radius - -33)
      end
    end
  end
end
