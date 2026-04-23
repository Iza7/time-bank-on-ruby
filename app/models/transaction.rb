class Transaction < ApplicationRecord
  TYPES = %w[credit debit].freeze

  belongs_to :user
  belongs_to :service_request

  validates :amount,           presence: true, numericality: { only_integer: true, other_than: 0 }
  validates :transaction_type, inclusion: { in: TYPES }
  validates :description,      presence: true
end
