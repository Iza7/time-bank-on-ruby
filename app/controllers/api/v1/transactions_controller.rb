class Api::V1::TransactionsController < Api::V1::BaseController
  def index
    transactions = current_api_user.transactions
                                   .includes(:service_request)
                                   .order(created_at: :desc)

    render json: transactions.map { |t| serialize(t) }
  end

  private

  def serialize(txn)
    {
      id: txn.id,
      amount: txn.amount,
      transaction_type: txn.transaction_type,
      description: txn.description,
      service_request_id: txn.service_request_id,
      created_at: txn.created_at
    }
  end
end
