class Payment < ApplicationRecord
  belongs_to :user
  
  validates :credits_purchased, presence: true
  validates :stripe_session_id, presence: true
  validates :status, inclusion: { in: %w[pending completed failed] }
end