# frozen_string_literal: true

require 'rails_helper'

describe 'ヘルプ機能', type: :system do
  describe 'HOMEボタン機能' do
    before do
      visit help_index_path
    end

    context 'ヘルプ画面を表時したとき' do
      it 'HOMEボタンが表示される' do
        expect(find_by_id('home')).to have_content 'HOME'
      end
    end
  end
end
