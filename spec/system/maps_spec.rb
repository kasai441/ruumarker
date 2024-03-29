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
        expect(find_by_id('preview-image')[:src]).to include 'sample_map.png'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '画像が登録されてルームに遷移する' do
        expect(find_by_id('show-image')[:src]).to include 'test_image.jpg'
        expect(page).to have_selector 'h2', text: '入居時チェック表'
      end
    end

    context '画像をアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '初期のトリミングが0x0になる' do
        left, top = pixel(find_by_id('show-image'), 'left', 'top')
        expect(left).to eq 0
        expect(top).to eq 0
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'not_image.jpg'), make_visible: true
      end

      it '画像が変化しない' do
        expect(page).to have_selector '.alert-error', text: 'アップロードするのは「 jpg / jpeg / png / gif 」のいずれかの画像ファイルである必要があります'
        expect(page).to have_selector '#preview-image'
        expect(find_by_id('preview-image')[:src]).to include 'sample_map.png'
      end
    end

    context '制約幅以下の画像ファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), make_visible: true
      end

      it '画像幅が元のままとなる' do
        expect(page).to have_selector '#show-image'
        expect(execute_script('return arguments[0].naturalWidth',
                              find_by_id('show-image'))).to eq 88
      end
    end

    context '制約幅以上の画像ファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'large_image.jpg'), make_visible: true
      end

      it '画像が制約幅になる' do
        max = 800
        expect(page).to have_selector '#show-image'
        expect(execute_script('return arguments[0].naturalWidth',
                              find_by_id('show-image'))).to eq max
      end
    end

    context 'タイトルバーにて' do
      let(:title_bar) { find_by_id('title-bar') }

      it 'チェック表作成ボタンが表示されずにHELPボタンが表示される' do
        within(title_bar) do
          expect(page).not_to have_content 'チェック表作成'
          expect(page).to have_content 'HELP'
        end
      end

      it 'PRINTボタンが表示されない' do
        within(title_bar) do
          expect(page).not_to have_content 'PRINT'
        end
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
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-image').native, 42, -25
        ).perform
        find_by_id('update').click
      end

      it 'トリミングが保存され、詳細画面で反映されている' do
        left, top = pixel(find_by_id('show-image'), 'left', 'top')
        expect(left).to be_within(1).of(to_show_size(42))
        expect(top).to be_within(1).of(to_show_size(-25))
      end
    end

    context '画像をアップロードしたとき' do
      before do
        expect(find_by_id('edit-image')[:src]).to include 'test_image.jpg'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
      end

      it '画像が変更される' do
        expect(find_by_id('edit-image')[:src]).not_to include 'test_image.jpg'
        expect(find_by_id('edit-image')[:src]).to include 'data:image/png'
      end
    end

    context '画像以外のファイルをアップロードしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'not_image.jpg'), make_visible: true
      end

      it '更新を失敗して画面がそのまま遷移しない' do
        expect(page).to have_selector '.alert-error', text: 'アップロードするのは「 jpg / jpeg / png / gif 」のいずれかの画像ファイルである必要があります'
        expect(page).to have_selector '#edit-image'
      end
    end

    context '画像をアップロードして保存を押したとき' do
      before do
        expect(find_by_id('edit-image')[:src]).to include 'test_image.jpg'
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
        find_by_id('update').click
      end

      it '画像が更新されている' do
        expect(find_by_id('show-image')[:src]).to include 'test_image.png'
      end
    end

    context '画像をアップロードしてトリミングしたとき' do
      before do
        attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-image').native, -27, 37
        ).perform
        find_by_id('update').click
      end

      it '更新内容が反映される' do
        left, top = pixel(find_by_id('show-image'), 'left', 'top')
        expect(left).to be_within(1).of(to_show_size(-27))
        expect(top).to be_within(1).of(to_show_size(37))
      end
    end

    let!(:limitX) { pixel(find_by_id('edit-field'), 'width') / 4 }
    let!(:limitY) { pixel(find_by_id('edit-field'), 'height') / 4 }

    context '画面編集時に上限以上のトリミングを行ったとき' do
      before do
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-image').native, limitX + 10, limitY + 10
        ).perform
        find_by_id('update').click
      end

      it '上限のトリミング幅となる' do
        left, top = pixel(find_by_id('show-image'), 'left', 'top')
        expect(left).to be_within(1).of(to_show_size(limitX))
        expect(top).to be_within(1).of(to_show_size(limitY))
      end
    end

    context '画面編集時に下限以下のトリミングを行ったとき' do
      before do
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-image').native, -limitX - 10, -limitY - 10
        ).perform
        find_by_id('update').click
      end

      it '下限のトリミング幅となる' do
        left, top = pixel(find_by_id('show-image'), 'left', 'top')
        expect(left).to be_within(1).of(to_show_size(-limitX))
        expect(top).to be_within(1).of(to_show_size(-limitY))
      end
    end

    context 'タイトルバーにて' do
      let(:title_bar) { find_by_id('title-bar') }

      it 'チェック表作成ボタンが表示されずにHELPボタンが表示される' do
        within(title_bar) do
          expect(page).not_to have_content 'チェック表作成'
          expect(page).to have_content 'HELP'
        end
      end

      it 'PRINTボタンが表示されない' do
        within(title_bar) do
          expect(page).not_to have_content 'PRINT'
        end
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

    context '3つのマークをそれぞれ移動した時' do
      before do
        find_by_id("mark-#{mark3.id}").click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-location-image').native, -33, -33
        ).perform
        find_by_id('update').click

        find_by_id("mark-#{mark2.id}").click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-location-image').native, 22, 22
        ).perform
        find_by_id('update').click

        find_by_id("mark-#{mark1.id}").click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-location-image').native, -11, -11
        ).perform
        find_by_id('update').click

        find_by_id('image-edit').click
      end

      it '移動分がマップ編集画面で反映されている' do
        mark_radius = 14
        w, h = pixel(find_by_id('edit-field'), 'width', 'height')

        left, top = pixel(find_by_id("locator-#{mark1.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - mark_radius - -11)
        expect(top).to be_within(1).of(h / 2 - mark_radius - -11)

        left, top = pixel(find_by_id("locator-#{mark2.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - mark_radius - 22)
        expect(top).to be_within(1).of(h / 2 - mark_radius - 22)

        left, top = pixel(find_by_id("locator-#{mark3.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - mark_radius - -33)
        expect(top).to be_within(1).of(h / 2 - mark_radius - -33)
      end
    end
  end
end
