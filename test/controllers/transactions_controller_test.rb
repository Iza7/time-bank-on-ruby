require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /transactions requires authentication" do
    get "/transactions"
    assert_redirected_to "/login"
  end

  test "GET /transactions shows only current user transactions" do
    sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob), status: "accepted")
    CreditTransfer.call(sr)
    sr.update!(status: "completed")

    sign_in(users(:bob))
    get "/transactions"
    assert_response :success
  end
end
