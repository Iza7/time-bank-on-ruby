require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "GET /profile requires authentication" do
    get "/profile"
    assert_redirected_to "/login"
  end

  test "GET /profile renders for authenticated user" do
    sign_in(users(:alice))
    get "/profile"
    assert_response :success
  end

  test "GET /profile/edit requires authentication" do
    get "/profile/edit"
    assert_redirected_to "/login"
  end

  test "GET /profile/edit renders edit form for authenticated user" do
    sign_in(users(:alice))
    get "/profile/edit"
    assert_response :success
  end

  test "PATCH /profile updates name" do
    sign_in(users(:alice))
    patch "/profile", params: { user: { name: "Alice Updated", email: users(:alice).email } }
    assert_redirected_to "/profile"
    assert_equal "Alice Updated", users(:alice).reload.name
  end

  test "PATCH /profile with invalid email re-renders edit form" do
    sign_in(users(:alice))
    patch "/profile", params: { user: { name: "Alice", email: "bad-email" } }
    assert_response :unprocessable_entity
  end

  test "PATCH /profile does not update password when left blank" do
    sign_in(users(:alice))
    original_digest = users(:alice).password_digest
    patch "/profile", params: { user: { name: "Alice", email: users(:alice).email, password: "" } }
    assert_equal original_digest, users(:alice).reload.password_digest
  end
end
