# frozen_string_literal: true

require 'rails_helper'

describe 'マップ管理機能', type: :system do
  describe '新規作成機能' do
    before do
      visit new_room_path
      fill_in 'Trimming', with: '10, 20'
      fill_in 'Expansion', with: '30'
      fill_in 'Rotation', with: '40'
      click_button '登録する'
    end

    it '正常に登録される' do
      expect(page).to have_selector '.alert-success', text: '登録しました'
      expect(page).to have_selector '.trimming', text: '10, 20'
      expect(page).to have_selector '.expansion', text: '30'
      expect(page).to have_selector '.rotation', text: '40'
    end
  end

  describe '更新機能' do
    let(:room1) { FactoryBot.create(:room) }
    let!(:map1) { FactoryBot.create(:map, room: room1) }

    before do
      visit room_path(room1)
      click_link 'マップ編集'
      fill_in 'Trimming', with: '1, 2'
      fill_in 'Expansion', with: '3'
      fill_in 'Rotation', with: '4'
      click_button '更新する'
    end

    it '正常に登録される' do
      expect(page).to have_selector '.alert-success', text: '変更しました'
      expect(page).to have_selector '.trimming', text: '1, 2'
      expect(page).to have_selector '.expansion', text: '3'
      expect(page).to have_selector '.rotation', text: '4'
    end
  end
end
