# frozen_string_literal: true

require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get rooms_show_url
    assert_response :success
  end

  test 'should get new' do
    get rooms_new_url
    assert_response :success
  end

  test 'should get edit' do
    get rooms_edit_url
    assert_response :success
  end

  test 'should get destroy' do
    get rooms_destroy_url
    assert_response :success
  end
end
