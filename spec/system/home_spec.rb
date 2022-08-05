# frozen_string_literal: true

require 'rails_helper'

describe 'ホーム機能', type: :system do
  describe 'cookieによるルーム記憶機能' do
    before do
      visit root_path
    end

    context '1度目にホームページにアクセスしたとき' do
      it 'ホームページが表示される' do
        expect(page).to have_selector '.btn', text: '入居時チェック表を作る'
      end
    end

    context '2度目にホームページにアクセスしたとき' do
      let(:room1) { FactoryBot.create(:room) }
      let!(:map1) { FactoryBot.create(:map, room: room1) }
      let(:show_image) { find_by_id('show-image') }

      before do
        visit room_path(room1)
        visit root_path
      end

      it '1度目につくったルームにリダイレクトされる' do
        expect(page).to have_selector 'h2', text: '入居時チェック表'
        expect(show_image[:src]).to include 'test_image.jpg'
      end
    end
  end

  describe 'HOMEボタン機能' do
    before do
      visit root_path
    end

    context 'タイトルバーにて' do
      it 'HOMEボタンが表示される' do
        title_bar = find_by_id('title-bar')
        within(title_bar) do
          expect(page).to have_content 'HOME'
        end
      end
    end
  end
end
