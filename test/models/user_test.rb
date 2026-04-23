require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user
    User.new(name: "Test", email: "test@example.com", password: "password123", role: "user", balance: 10)
  end

  test "valid user saves" do
    assert valid_user.valid?
  end

  test "requires name" do
    u = valid_user
    u.name = ""
    assert_not u.valid?
    assert_includes u.errors[:name], "can't be blank"
  end

  test "requires email" do
    u = valid_user
    u.email = ""
    assert_not u.valid?
  end

  test "rejects invalid email format" do
    u = valid_user
    u.email = "not-an-email"
    assert_not u.valid?
    assert u.errors[:email].any?
  end

  test "rejects duplicate email (case-insensitive)" do
    valid_user.save!
    dup = valid_user.dup
    dup.email = "TEST@EXAMPLE.COM"
    assert_not dup.valid?
    assert_includes dup.errors[:email], "has already been taken"
  end

  test "rejects password shorter than 8 characters" do
    u = valid_user
    u.password = "short"
    assert_not u.valid?
  end

  test "allows nil password on update" do
    u = valid_user
    u.save!
    u.password = nil
    assert u.valid?
  end

  test "rejects invalid role" do
    u = valid_user
    u.role = "superuser"
    assert_not u.valid?
  end

  test "rejects negative balance" do
    u = valid_user
    u.balance = -1
    assert_not u.valid?
  end

  test "authenticates with correct password" do
    u = valid_user
    u.save!
    assert u.authenticate("password123")
  end

  test "does not authenticate with wrong password" do
    u = valid_user
    u.save!
    assert_not u.authenticate("wrongpassword")
  end
end
