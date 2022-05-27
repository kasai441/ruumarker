# frozen_string_literal: true

require 'rails_helper'
require 'support/dom_helper'

describe 'キズ管理機能', type: :system do
  include DomHelper

  describe '新規作成機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
    end

    context '「キズ追加ボタン」を押したとき' do
      let!(:ex_marks_count) { Mark.all.count }
      let(:edit_image) { find('#edit-image') }

      before do
        find('#create-mark').click
      end

      it '登録され、キズ編集画面に遷移し、サンプルのキズ画像が表示される' do
        expect(Mark.all.count).to eq ex_marks_count + 1
        expect(page).to have_selector 'h1', text: 'キズ情報'
        expect(page).to have_selector '#edit-image'
        expect(edit_image[:src]).to include 'sample.png'
      end
    end
  end

  describe '更新機能' do
    let(:room1) { FactoryBot.create(:room) }
    let(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }

    before do
      visit room_path(room1)
      find("#mark-#{mark1.id}").click
    end

    describe 'キズ画像トリミング機能' do
      let(:edit_image) { page.find_by_id('edit-image') }
      let(:edit_field) { page.find_by_id('edit-field') }
      let!(:ex_left) { style_px_to_i(edit_image, 'left') }
      let!(:ex_top) { style_px_to_i(edit_image, 'top') }
      let!(:edit_field_width) { style_px_to_i(edit_field, 'width') }
      let!(:edit_field_height) { style_px_to_i(edit_field, 'height') }
      let!(:constrainRangeX) { edit_field_width / 4 }
      let!(:constrainRangeY) { edit_field_height / 4 }
      let!(:ex_upload) { page.find_by_id('edit-image')[:src] }
      let(:move_x) { edit_field_width / 5 }
      let(:move_y) { edit_field_height / 5 }

      context '編集画面にてトリミング操作を行ったとき' do
        before do
          page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
          find('#update').click
        end

        it 'トリミングが保存され、もう一度編集画面を開くとトリミングが反映されている' do
          # expect(page).to have_selector '.alert-success', text: '変更しました
          expect(page).to have_selector 'h1', text: 'キズ点検表'
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-image'
          edit_image = page.find_by_id('edit-image')
          left = style_px_to_i(edit_image, 'left')
          top = style_px_to_i(edit_image, 'top')
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
          expect(page.find_by_id('edit-image')[:src]).to include 'test_image.jpg'
          attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'not_image.jpg'), make_visible: true
        end

        it '更新を失敗して画像が変化しない' do
          # expect(page).to have_selector '#error_explanation', text: 'マップの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
          expect(page.find_by_id('edit-image')[:src]).to include 'test_image.jpg'
        end
      end

      context '画像をアップロードして変更を押したとき' do
        before do
          expect(edit_image[:src]).to include 'test_image.jpg'
          attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
          find('#update').click
        end

        it '画像が更新されている' do
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-image'
          edit_image = page.find_by_id('edit-image')
          expect(edit_image[:src]).to include 'test_image.png'
        end
      end

      context '画像をアップロードしてトリミングしたとき' do
        before do
          attach_file 'file', Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), make_visible: true
          page.driver.browser.action.drag_and_drop_by(edit_image.native, move_x, move_y).perform
          find('#update').click
        end

        it '更新内容が反映される' do
          # expect(page).to have_selector '.alert-success', text: '変更しました
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-image'
          edit_image = page.find_by_id('edit-image')
          left = style_px_to_i(edit_image, 'left')
          top = style_px_to_i(edit_image, 'top')
          expect(left).to be_within(2).of(ex_left + move_x)
          expect(top).to be_within(2).of(ex_top + move_y)
        end
      end

      context '画面編集時に上限以上のトリミングを行ったとき' do
        before do
          page.driver.browser.action.drag_and_drop_by(edit_image.native, constrainRangeX + 10,
                                                      constrainRangeY + 10).perform
          find('#update').click
        end

        it '上限のトリミング幅となる' do
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-image'
          edit_image = page.find_by_id('edit-image')
          left = style_px_to_i(edit_image, 'left')
          top = style_px_to_i(edit_image, 'top')
          expect(left).to be_within(2).of(ex_left + constrainRangeX)
          expect(top).to be_within(2).of(ex_top + constrainRangeY)
        end
      end

      context '画面編集時に下限以下のトリミングを行ったとき' do
        before do
          page.driver.browser.action.drag_and_drop_by(edit_image.native, -constrainRangeX - 10,
                                                      -constrainRangeY - 10).perform
          find('#update').click
        end

        it '下限のトリミング幅となる' do
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-image'
          edit_image = page.find_by_id('edit-image')
          left = style_px_to_i(edit_image, 'left')
          top = style_px_to_i(edit_image, 'top')
          expect(left).to be_within(2).of(ex_left - constrainRangeX)
          expect(top).to be_within(2).of(ex_top - constrainRangeY)
        end
      end
    end

    describe 'キズ概要テキスト入力機能' do
      context 'キズの概要をテキストエリアに入力して更新したとき' do
        before do
          fill_in 'edit-description', with: '壁紙はがれかけ、50cm'
          find('#update').click
        end

        it '変更が反映される' do
          expect(page).to have_content '壁紙はがれかけ、50…'
        end
      end

      context 'キズの概要のテキストに漢字ひらがな数字記号を混ぜて入力して更新したとき' do
        before do
          fill_in 'edit-description', with: '滲み　（２個所）⁉️？ ( 100cm )️'
          find('#update').click
        end

        it '変更が反映される' do
          tr = find("#mark-#{mark1.id}")
          within(tr) do
            expect(page).to have_content '滲み　（２個所）⁉️…'
          end
          tr.click
          expect(find('#edit-description').value).to eq '滲み　（２個所）⁉️？ ( 100cm )️'
        end
      end

      context '制限文字数以上の入力をして登録したとき' do
        before do
          fill_in 'edit-description', with: 'a' * 61
        end

        it '入力が60以上できず、制限文字数で登録される' do
          expect(find('#edit-description').value.length).to eq 60
          find('#update').click
          find("#mark-#{mark1.id}").click
          expect(find('#edit-description').value.length).to eq 60
        end
      end
    end

    describe 'キズ配置機能' do
      let(:edit_location_image) { page.find_by_id('edit-location-image') }
      let(:edit_location_field) { page.find_by_id('edit-location-field') }
      let!(:ex_left) { style_px_to_i(edit_location_image, 'left') }
      let!(:ex_top) { style_px_to_i(edit_location_image, 'top') }
      let!(:edit_location_field_width) { style_px_to_i(edit_location_field, 'width') }
      let!(:edit_location_field_height) { style_px_to_i(edit_location_field, 'height') }
      let!(:constrainRangeX) { edit_location_field_width / 2 - 2 }
      let!(:constrainRangeY) { edit_location_field_height / 2 - 2 }
      let(:move_x) { edit_location_field_width / 4 }
      let(:move_y) { edit_location_field_height / 4 }

      context '編集画面にて配置を変更したとき' do
        before do
          page.driver.browser.action.drag_and_drop_by(edit_location_image.native, move_x, move_y).perform
          find('#update').click
        end

        it '配置が保存され、もう一度編集画面を開くと変更が反映されている' do
          # expect(page).to have_selector '.alert-success', text: '変更しました
          expect(page).to have_selector 'h1', text: 'キズ点検表'
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-location-image'
          edit_location_image = page.find_by_id('edit-location-image')
          left = style_px_to_i(edit_location_image, 'left')
          top = style_px_to_i(edit_location_image, 'top')
          expect(left).to be_within(2).of(ex_left + move_x)
          expect(top).to be_within(2).of(ex_top + move_y)
        end
      end

      context '画面編集時に上限以上の配置移動を行ったとき' do
        before do
          page.driver.browser.action
              .move_to(edit_location_image.native, 0, 0)
              .click_and_hold.move_by(constrainRangeX + 10, constrainRangeY + 10)
              .release.perform
          find('#update').click
        end

        it '上限の配置移動幅となる' do
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-location-image'
          edit_location_image = page.find_by_id('edit-location-image')
          left = style_px_to_i(edit_location_image, 'left')
          top = style_px_to_i(edit_location_image, 'top')
          expect(left).to be_within(2).of(ex_left + constrainRangeX)
          expect(top).to be_within(2).of(ex_top + constrainRangeY)
        end
      end

      context '画面編集時に下限以下の配置移動を行ったとき' do
        before do
          page.driver.browser.action
              .move_to(edit_location_image.native, edit_location_field_width - 1, edit_location_field_height - 1)
              .click_and_hold.move_by(-constrainRangeX - 10, -constrainRangeY - 10)
              .release.perform
          find('#update').click
        end

        it '下限の配置移動幅となる' do
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-location-image'
          edit_location_image = page.find_by_id('edit-location-image')
          left = style_px_to_i(edit_location_image, 'left')
          top = style_px_to_i(edit_location_image, 'top')
          expect(left).to be_within(2).of(ex_left - constrainRangeX)
          expect(top).to be_within(2).of(ex_top - constrainRangeY)
        end
      end

      context 'トリミングされたマップで配置移動をするとき' do
        let(:trim_x) { 100 }
        let(:trim_y) { -15 }
        let(:locate_x) { -10 }
        let(:locate_y) { 100 }
        before do
          visit root_path
          find('#image-edit').click
          edit_image = page.find_by_id('edit-image')
          page.driver.browser.action.drag_and_drop_by(edit_image.native, trim_x, trim_y).perform
          find('#update').click

          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-location-image'
          edit_location_image = page.find_by_id('edit-location-image')
          page.driver.browser.action.drag_and_drop_by(edit_location_image.native, locate_x, locate_y).perform
          find('#update').click
        end

        it 'フレームと画像が配置移動分だけ移動して、フレームはトリミング分だけ反対方向に移動する' do
          # expect(page).to have_selector '.alert-success', text: '変更しました
          expect(page).to have_selector 'h1', text: 'キズ点検表'
          find("#mark-#{mark1.id}").click
          expect(page).to have_selector '#edit-location-image'
          edit_location_frame = page.find_by_id('edit-location-frame')
          edit_location_image = page.find_by_id('edit-location-image')
          frame_left = style_px_to_i(edit_location_frame, 'left')
          frame_top = style_px_to_i(edit_location_frame, 'top')
          image_left = style_px_to_i(edit_location_image, 'left')
          image_top = style_px_to_i(edit_location_image, 'top')
          expect(frame_left).to be_within(4).of(ex_left - trim_x + locate_x)
          expect(frame_top).to be_within(4).of(ex_top - trim_y + locate_y)
          expect(image_left).to be_within(4).of(ex_left + locate_x)
          expect(image_top).to be_within(4).of(ex_top + locate_y)
        end
      end
    end
  end

  describe '削除機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }
    let!(:mark1) { FactoryBot.create(:mark, map: map1) }
    let!(:ex_marks_count) { Mark.all.count }

    context 'キズ一覧の中からあるキズを削除する' do
      before do
        visit room_path(room1)
        page.accept_confirm do
          within("#mark-#{mark1.id}") do
            click_link('×')
          end
        end
      end

      it 'キズが正常に削除される' do
        expect(page).to have_selector '.alert-success', text: '削除しました'
        expect(page).not_to have_selector "#mark-#{mark1.id}"
        expect(Mark.all.count).to eq ex_marks_count - 1
      end
    end
  end
end
