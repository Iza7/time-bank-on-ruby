class Admin::TransactionsController < Admin::BaseController

  def index
    @transactions = Transaction.includes(service_request: [ :requester, { service: :user } ]).all
  end
end
