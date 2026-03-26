require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get pages_profile_url
    assert_response :success
  end
end
