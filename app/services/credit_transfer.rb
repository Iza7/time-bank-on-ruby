module CreditTransfer
  InsufficientBalance = Class.new(StandardError)

  def self.call(service_request)
    requester = service_request.requester
    provider  = service_request.provider
    amount    = service_request.service.duration
    title     = service_request.service.title

    ActiveRecord::Base.transaction do
      requester.with_lock do
        # Raise a StandardError subclass — unlike ActiveRecord::Rollback, it
        # propagates OUT of the transaction block (after rolling back) so the
        # rescue below can catch it and return false.
        raise InsufficientBalance if requester.balance < amount

        requester.decrement!(:balance, amount)
      end

      provider.increment!(:balance, amount)

      Transaction.create!(
        user: requester, service_request: service_request,
        amount: -amount, transaction_type: "debit",
        description: "Payment for: #{title}"
      )
      Transaction.create!(
        user: provider, service_request: service_request,
        amount: amount, transaction_type: "credit",
        description: "Payment received for: #{title}"
      )
    end

    true
  rescue InsufficientBalance
    false
  end
end
