require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /login renders login form" do
    get "/login"
    assert_response :success
  end

  test "POST /login with valid credentials sets session and redirects" do
    post "/login", params: { email: users(:alice).email, password: "password123" }
    assert_redirected_to "/profile"
    assert_equal users(:alice).id, session[:user_id]
  end

  test "POST /login is case-insensitive on email" do
    post "/login", params: { email: users(:alice).email.upcase, password: "password123" }
    assert_redirected_to "/profile"
  end

  test "POST /login with wrong password re-renders form" do
    post "/login", params: { email: users(:alice).email, password: "wrongpassword" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "POST /login with unknown email re-renders form" do
    post "/login", params: { email: "nobody@example.com", password: "password123" }
    assert_response :unprocessable_entity
  end

  test "DELETE /logout clears session and redirects to login" do
    sign_in(users(:alice))
    delete "/logout"
    assert_redirected_to "/login"
    assert_nil session[:user_id]
  end
end
