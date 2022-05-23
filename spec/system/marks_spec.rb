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
      within("#mark-#{mark1.id}") do
        click_link('変更')
      end
    end

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
        within("#mark-#{mark1.id}") do
          click_link('変更')
        end
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
        within("#mark-#{mark1.id}") do
          click_link('変更')
        end
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
        within("#mark-#{mark1.id}") do
          click_link('変更')
        end
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
        within("#mark-#{mark1.id}") do
          click_link('変更')
        end
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
        within("#mark-#{mark1.id}") do
          click_link('変更')
        end
        expect(page).to have_selector '#edit-image'
        edit_image = page.find_by_id('edit-image')
        left = style_px_to_i(edit_image, 'left')
        top = style_px_to_i(edit_image, 'top')
        expect(left).to be_within(2).of(ex_left - constrainRangeX)
        expect(top).to be_within(2).of(ex_top - constrainRangeY)
      end
    end

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
        within("#mark-#{mark1.id}") do
          expect(page).to have_content '滲み　（２個所）⁉️…'
          click_link('変更')
        end
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
        within("#mark-#{mark1.id}") do
          click_link('変更')
        end
        expect(find('#edit-description').value.length).to eq 60
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
            click_link('削除')
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
