class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions
                                .includes(:service_request)
                                .order(created_at: :desc)
  end
end
