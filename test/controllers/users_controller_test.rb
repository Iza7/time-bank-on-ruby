require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "GET /register renders registration form" do
    get "/register"
    assert_response :success
  end

  test "POST /users with valid params creates user and redirects to login" do
    assert_difference("User.count") do
      post "/users", params: { user: { name: "New User", email: "new@example.com", password: "password123" } }
    end
    assert_redirected_to "/login"
  end

  test "new user gets balance of 10 and role of user" do
    post "/users", params: { user: { name: "New User", email: "new@example.com", password: "password123" } }
    user = User.find_by(email: "new@example.com")
    assert_equal 10, user.balance
    assert_equal "user", user.role
  end

  test "POST /users with missing name re-renders form" do
    assert_no_difference("User.count") do
      post "/users", params: { user: { name: "", email: "new@example.com", password: "password123" } }
    end
    assert_response :unprocessable_entity
  end

  test "POST /users with invalid email re-renders form" do
    assert_no_difference("User.count") do
      post "/users", params: { user: { name: "New User", email: "bad-email", password: "password123" } }
    end
    assert_response :unprocessable_entity
  end

  test "POST /users with short password re-renders form" do
    assert_no_difference("User.count") do
      post "/users", params: { user: { name: "New User", email: "new@example.com", password: "short" } }
    end
    assert_response :unprocessable_entity
  end
end
