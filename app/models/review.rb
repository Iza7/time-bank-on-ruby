class Review < ApplicationRecord
  belongs_to :service_request
  belongs_to :reviewer, class_name: 'User'

  validates :rating, presence: true,
                     inclusion: { in: 1..5 }
  validates :body, presence: true
  validates :service_request_id, uniqueness: { scope: :reviewer_id,
             message: "You have already reviewed this service" }

  validate :service_must_be_completed

  private

  def service_must_be_completed
    unless service_request&.completed?
      errors.add(:base, "Can only review completed services")
    end
  end
end