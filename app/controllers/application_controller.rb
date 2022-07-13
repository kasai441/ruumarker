# frozen_string_literal: true

class ApplicationController < ActionController::Base
  after_action :flash_to_headers

  private

  def flash_to_headers
    return unless request.xhr?

    response.headers['X-Flash-Messages'] = flash_json
  end

  def flash_json
    flash.inject({}) do |hash, (type, message)|
      message = "#{ERB::Util.html_escape(message)}"
      message = URI.encode_www_form_component(message)
      hash[type] = message
      hash
    end.to_json
  end
end
