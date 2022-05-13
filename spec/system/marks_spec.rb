# frozen_string_literal: true

require 'rails_helper'

describe 'キズ管理機能', type: :system do
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

  # describe '更新機能' do
  #   let(:room1) { FactoryBot.create(:room) }
  #   let!(:map1) { FactoryBot.create(:map, room: room1) }
  #   let!(:mark1) { FactoryBot.create(:mark, map: map1) }
  #
  #   before do
  #     visit room_mark_path(room1, mark1)
  #     click_link 'キズ編集'
  #   end
  #
  #   context '詳細画面から更新ボタンを押したとき' do
  #     before do
  #       expect(page).to have_selector '#show-image'
  #       find('#edit').click
  #       # エラー時のJSからのメッセージの表示
  #       # puts page.driver.browser.manage.logs.get(:browser).collect(&:message)
  #     end
  #
  #     it '編集画面に遷移する' do
  #       expect(page).to have_selector '#edit-image'
  #     end
  #   end
  #
  #   context '値を変更したとき' do
  #     before do
  #       fill_in 'Trimming', with: '1, 2'
  #       click_button '更新する'
  #     end
  #
  #     it '正常に登録される' do
  #       expect(page).to have_selector '.alert-success', text: '変更しました'
  #       expect(page).to have_selector '.trimming', text: '1, 2'
  #       expect(page).to have_selector '.image img'
  #     end
  #   end
  #
  #   context '画像以外のファイルをアップロードしたとき' do
  #     before do
  #       attach_file 'mark_image', Rails.root.join('spec', 'fixtures', 'files', 'test_zip.zip')
  #       click_button '更新する'
  #     end
  #
  #     it '更新を失敗して編集画面にもどされる' do
  #       expect(page).to have_selector '#error_explanation', text: 'キズの画像ファイルは[jpg/jpeg/png/gif]の形式のみ受け付けています'
  #       expect(page).to have_content 'キズ情報を変更します'
  #     end
  #   end
  # end

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
