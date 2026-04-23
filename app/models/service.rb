class Service < ApplicationRecord
  belongs_to :user
  has_many :service_requests, dependent: :destroy

  validates :title,       presence: true
  validates :description, presence: true
  validates :duration,    numericality: { only_integer: true, greater_than: 0 }
end
