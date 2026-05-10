class User < ApplicationRecord
  has_secure_password

  has_many :services,         dependent: :destroy
  has_many :service_requests, foreign_key: :requester_id, dependent: :destroy, inverse_of: :requester
  has_many :transactions,     dependent: :destroy

  validates :name,     presence: true
  validates :email,    presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :role,     inclusion: { in: %w[user admin] }
  validates :balance,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :payments
  has_many :reviews, foreign_key: :reviewer_id

  def admin?
    self[:admin] || role == "admin"
  end
end
