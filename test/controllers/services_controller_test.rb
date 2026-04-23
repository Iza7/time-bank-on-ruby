require "test_helper"

class ServicesControllerTest < ActionDispatch::IntegrationTest
  test "GET /services requires authentication" do
    get "/services"
    assert_redirected_to "/login"
  end

  test "GET /services renders for authenticated user" do
    sign_in(users(:alice))
    get "/services"
    assert_response :success
  end

  test "GET /services/new requires authentication" do
    get "/services/new"
    assert_redirected_to "/login"
  end

  test "POST /services creates service for current user" do
    sign_in(users(:alice))
    assert_difference("Service.count") do
      post "/services", params: { service: { title: "Cooking", description: "I will cook for you." } }
    end
    assert_redirected_to "/services"
    assert_equal users(:alice).id, Service.last.user_id
  end

  test "POST /services with missing title re-renders form" do
    sign_in(users(:alice))
    assert_no_difference("Service.count") do
      post "/services", params: { service: { title: "", description: "No title." } }
    end
    assert_response :unprocessable_entity
  end
end
