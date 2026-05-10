class ServiceRequest < ApplicationRecord
  STATUSES = %w[pending accepted rejected cancelled completed].freeze

  belongs_to :service
  belongs_to :requester, class_name: "User", inverse_of: :service_requests
  has_many   :transactions, dependent: :destroy
  has_one    :review

  validates :status, inclusion: { in: STATUSES }
  validate  :cannot_request_own_service
  validate  :requester_has_sufficient_balance, on: :create

  def provider
    service.user
  end

  def pending?   = status == "pending"
  def accepted?  = status == "accepted"
  def rejected?  = status == "rejected"
  def cancelled? = status == "cancelled"
  def completed? = status == "completed"

  private

  def cannot_request_own_service
    return unless service && requester
    errors.add(:base, "You cannot request your own service.") if service.user_id == requester_id
  end

  def requester_has_sufficient_balance
    return unless service && requester
    if requester.balance < service.duration
      errors.add(:base, "Insufficient balance. You need #{service.duration} credit(s) but have #{requester.balance}.")
    end
  end
end
