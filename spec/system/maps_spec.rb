# frozen_string_literal: true

require 'rails_helper'

describe 'マップ管理機能', type: :system do
  describe '新規作成機能' do
    before do
      visit new_room_path
      fill_in 'Trimming', with: '10, 20'
      fill_in 'Expansion', with: '50'
      fill_in 'Rotation', with: '45'
      click_button '登録する'
    end

    it '正常に登録される' do
      expect(page).to have_selector '.alert-success', text: '登録しました'
    end
  end
end
