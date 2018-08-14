require 'test_helper'

class FoodtruckControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get foodtruck_index_url
    assert_response :success
  end

end
