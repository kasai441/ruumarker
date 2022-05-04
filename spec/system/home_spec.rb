# frozen_string_literal: true

require 'rails_helper'

describe 'ホーム管理機能', type: :system do
  describe 'cookieによるルーム記憶機能' do
    before do
      visit root_path
    end

    context '1度目にホームページにアクセスしたとき' do
      it 'ホームページが表示される' do
        expect(page).to have_selector '.btn', text: 'キズ点検表を作る'
      end
    end

    context '2度目にホームページにアクセスしたとき' do
      let(:room1) { FactoryBot.create(:room) }
      let!(:map1) { FactoryBot.create(:map, room: room1) }

      before do
        visit room_path(room1)
        visit root_path
      end

      it '1度目につくったルームにリダイレクトされる' do
        expect(page).to have_selector '.trimming', text: '{"x":-25,"y":35}'
        expect(page).to have_selector '.expansion', text: '5'
        expect(page).to have_selector '.rotation', text: '6'
      end
    end
  end
end
