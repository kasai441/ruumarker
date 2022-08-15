# frozen_string_literal: true

require 'rails_helper'

describe 'ヘルプ機能', type: :system do
  describe 'チェック表作成ボタン機能' do
    before do
      visit help_index_path
    end

    context 'タイトルバーにて' do
      let(:title_bar) { find_by_id('title-bar') }

      it 'チェック表作成ボタンが表示されてHELPボタンが表示されない' do
        within(title_bar) do
          expect(page).to have_content 'チェック表作成'
          expect(page).not_to have_content 'HELP'
        end
      end

      it 'PRINTボタンが表示されない' do
        within(title_bar) do
          expect(page).not_to have_content 'PRINT'
        end
      end
    end
  end
end
