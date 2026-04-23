require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  def setup
    @sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob))
  end

  test "valid transaction saves" do
    txn = Transaction.new(user: users(:bob), service_request: @sr, amount: -1, transaction_type: "debit", description: "Payment")
    assert txn.valid?
  end

  test "requires description" do
    txn = Transaction.new(user: users(:bob), service_request: @sr, amount: -1, transaction_type: "debit", description: "")
    assert_not txn.valid?
  end

  test "rejects zero amount" do
    txn = Transaction.new(user: users(:bob), service_request: @sr, amount: 0, transaction_type: "debit", description: "Payment")
    assert_not txn.valid?
  end

  test "rejects invalid transaction type" do
    txn = Transaction.new(user: users(:bob), service_request: @sr, amount: -1, transaction_type: "refund", description: "Payment")
    assert_not txn.valid?
  end
end
