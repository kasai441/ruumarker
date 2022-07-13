# frozen_string_literal: true

class ApplicationController < ActionController::Base
  after_action :flash_to_headers

  private

  def flash_to_headers
    return unless request.xhr?

    response.headers['X-Flash-Messages'] = flash_json

    # ページをリロードした際に flash メッセージが残ってしまうのを防ぐ。
    flash.discard
  end

  def flash_json
    flash.inject({}) do |hash, (type, message)|
      # XSS 対策を施す。
      message = "#{ERB::Util.html_escape(message)}"
      # 日本語のメッセージをレスポンスヘッダに含めるために URL エンコードしておく。
      message = URI.encode_www_form_component(message)
      hash[type] = message
      hash
    end.to_json
  end
end
