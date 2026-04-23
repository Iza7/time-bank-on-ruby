require "test_helper"

class ServiceRequestTest < ActiveSupport::TestCase
  def setup
    @service   = services(:gardening)   # offered by alice, duration: 1
    @requester = users(:bob)            # balance: 5
  end

  test "valid request saves" do
    sr = ServiceRequest.new(service: @service, requester: @requester)
    assert sr.valid?
  end

  test "cannot request own service" do
    sr = ServiceRequest.new(service: @service, requester: users(:alice))
    assert_not sr.valid?
    assert_includes sr.errors[:base], "You cannot request your own service."
  end

  test "rejected when requester has insufficient balance" do
    users(:bob).update!(balance: 0)
    sr = ServiceRequest.new(service: @service, requester: users(:bob))
    assert_not sr.valid?
    assert sr.errors[:base].any? { |e| e.include?("Insufficient balance") }
  end

  test "defaults to pending status" do
    sr = ServiceRequest.create!(service: @service, requester: @requester)
    assert_equal "pending", sr.status
  end

  test "status predicate methods" do
    sr = ServiceRequest.create!(service: @service, requester: @requester)
    assert sr.pending?
    assert_not sr.accepted?

    sr.update!(status: "accepted")
    assert sr.accepted?
    assert_not sr.pending?
  end

  test "provider returns service owner" do
    sr = ServiceRequest.create!(service: @service, requester: @requester)
    assert_equal users(:alice), sr.provider
  end

  test "rejects invalid status" do
    sr = ServiceRequest.new(service: @service, requester: @requester, status: "unknown")
    assert_not sr.valid?
  end

  test "CreditTransfer transfers credits on success" do
    sr = ServiceRequest.create!(service: @service, requester: @requester, status: "accepted")
    alice_before = users(:alice).balance
    bob_before   = users(:bob).balance

    result = CreditTransfer.call(sr)

    assert result, "CreditTransfer should return true on success"
    assert_equal bob_before - @service.duration,   users(:bob).reload.balance
    assert_equal alice_before + @service.duration, users(:alice).reload.balance
    assert_equal 2, sr.transactions.count
  end

  test "CreditTransfer returns false when balance is insufficient" do
    # Create request while bob still has balance, then drain it to simulate
    # a concurrent depletion between request creation and completion.
    sr = ServiceRequest.create!(service: @service, requester: @requester, status: "accepted")
    users(:bob).update_column(:balance, 0)

    result = CreditTransfer.call(sr)

    assert_not result, "CreditTransfer should return false on insufficient balance"
    assert_equal 0, users(:bob).reload.balance,   "Requester balance should be unchanged"
    assert_equal 10, users(:alice).reload.balance, "Provider balance should be unchanged"
    assert_equal 0, sr.transactions.count,        "No transactions should be created"
  end
end
