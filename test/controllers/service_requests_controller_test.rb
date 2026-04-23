require "test_helper"

class ServiceRequestsControllerTest < ActionDispatch::IntegrationTest
  test "GET /service_requests requires authentication" do
    get "/service_requests"
    assert_redirected_to "/login"
  end

  test "GET /service_requests shows incoming and outgoing" do
    sign_in(users(:alice))
    get "/service_requests"
    assert_response :success
  end

  test "POST /service_requests creates a pending request" do
    sign_in(users(:bob))
    assert_difference("ServiceRequest.count") do
      post "/service_requests", params: { service_id: services(:gardening).id }
    end
    assert_equal "pending", ServiceRequest.last.status
    assert_equal users(:bob), ServiceRequest.last.requester
  end

  test "cannot request own service" do
    sign_in(users(:alice))
    assert_no_difference("ServiceRequest.count") do
      post "/service_requests", params: { service_id: services(:gardening).id }
    end
  end

  test "provider can accept a pending request" do
    sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob))
    sign_in(users(:alice))
    patch "/service_requests/#{sr.id}/accept"
    assert_equal "accepted", sr.reload.status
  end

  test "provider can reject a pending request" do
    sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob))
    sign_in(users(:alice))
    patch "/service_requests/#{sr.id}/reject"
    assert_equal "rejected", sr.reload.status
  end

  test "requester can cancel a pending request" do
    sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob))
    sign_in(users(:bob))
    patch "/service_requests/#{sr.id}/cancel"
    assert_equal "cancelled", sr.reload.status
  end

  test "complete transfers credits and marks request completed" do
    sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob), status: "accepted")
    alice_balance = users(:alice).balance
    bob_balance   = users(:bob).balance
    duration      = services(:gardening).duration

    sign_in(users(:alice))
    patch "/service_requests/#{sr.id}/complete"

    assert_equal "completed", sr.reload.status
    assert_equal bob_balance - duration,   users(:bob).reload.balance
    assert_equal alice_balance + duration, users(:alice).reload.balance
    assert_equal 2, sr.transactions.count
  end

  test "non-provider cannot accept" do
    sr = ServiceRequest.create!(service: services(:gardening), requester: users(:bob))
    sign_in(users(:bob))
    patch "/service_requests/#{sr.id}/accept"
    assert_equal "pending", sr.reload.status
  end
end
