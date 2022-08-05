# frozen_string_literal: true

require 'rails_helper'
require 'support/dom_helper'

describe 'ルーム管理機能', type: :system do
  include DomHelper

  describe '新規作成機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let(:preview) { find_by_id('preview-image') }

    before do
      visit root_path
    end

    context '「入居時チェック表を作る」ボタンを押したとき' do
      let!(:ex_rooms_count) { Room.all.count }

      before do
        find_by_id('create-room').click
      end

      it 'ルームが作成されてマップアップロード画面に遷移する' do
        expect(Room.all.count).to eq ex_rooms_count + 1
        expect(page).to have_selector '#preview-image'
        expect(preview[:src]).to include 'sample_map.png'
        expect(page).to have_selector 'h2', text: '間取り画像のアップロード'
      end
    end
  end

  describe '表示機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let!(:mark2) { FactoryBot.create(:mark, map: map1) }
    let(:show_image) { find_by_id('show-image') }
    let(:locator_radius) { 14 }

    before do
      visit room_path(room1)
    end

    context 'ルームにアクセスするとき' do
      it 'ルーム詳細画面に遷移し、マップ画像が表示され、キズの説明が表示される' do
        expect(page).to have_selector 'h2', text: '入居時チェック表'
        expect(show_image[:src]).to include 'test_image.jpg'
        expect(page).to have_content 'リビング、フローリングに削れ'
      end
    end

    context '初期のキズ作成時' do
      it 'キズが真ん中に表示されている' do
        w, h = pixel(find_by_id('show-image'), 'width', 'height')
        left, top = pixel(find_by_id("locator-#{mark1.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - locator_radius)
        expect(top).to be_within(1).of(h / 2 - locator_radius)
      end
    end

    context 'キズを2つ作ってそれぞれ移動したとき' do
      before do
        find_by_id("mark-#{mark1.id}").click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-location-image').native, 11, -21
        ).perform
        find_by_id('update').click

        find_by_id("mark-#{mark2.id}").click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-location-image').native, -31, 41
        ).perform
        find_by_id('update').click
      end

      it 'それぞれの位置に表示される' do
        w, h = pixel(find_by_id('show-image'), 'width', 'height')

        left, top = pixel(find_by_id("locator-#{mark1.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - locator_radius - 11)
        expect(top).to be_within(1).of(h / 2 - locator_radius + 21)

        left, top = pixel(find_by_id("locator-#{mark2.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - locator_radius + 31)
        expect(top).to be_within(1).of(h / 2 - locator_radius - 41)
      end
    end

    context 'キズを移動した後、マップのトリミングを変えたとき' do
      before do
        find_by_id("mark-#{mark1.id}").click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-location-image').native, -52, 42
        ).perform
        find_by_id('update').click

        find_by_id('image-edit').click
        page.driver.browser.action.drag_and_drop_by(
          find_by_id('edit-image').native, -32, -22
        ).perform
        find_by_id('update').click
      end

      it '画像の中でのキズの位置がキープされている（移動分＋トリミング分、動いている）' do
        w, h = pixel(find_by_id('show-image'), 'width', 'height')
        left, top = pixel(find_by_id("locator-#{mark1.id}"), 'left', 'top')
        expect(left).to be_within(1).of(w / 2 - locator_radius + 52 - 32)
        expect(top).to be_within(1).of(h / 2 - locator_radius - 42 - 22)
      end
    end

    context 'タイトルバーにて' do
      it 'HOMEボタンが表示されない' do
        title_bar = find_by_id('title-bar')
        within(title_bar) do
          expect(page).not_to have_content 'HOME'
        end
      end
    end
  end

  describe 'リンク' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let(:show_image) { find_by_id('show-image') }

    context 'タイトルをクリックするとき' do
      before do
        visit room_path(room1)
        find_by_id('title-logo').click
      end

      it 'ルーム詳細画面に遷移し、マップ画像が表示される' do
        expect(page).to have_selector 'h2', text: '入居時チェック表'
        expect(show_image[:src]).to include 'test_image.jpg'
      end
    end

    context '2回タイトルをクリックするとき' do
      before do
        visit room_path(room1)
        find_by_id('title-logo').click
        find_by_id('title-logo').click
      end

      it 'ルーム詳細画面に遷移し、マップ画像が表示される' do
        expect(page).to have_selector 'h2', text: '入居時チェック表'
        expect(show_image[:src]).to include 'test_image.jpg'
      end
    end
  end
end
