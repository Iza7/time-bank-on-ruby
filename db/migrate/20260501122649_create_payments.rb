class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :credits_purchased
      t.string :stripe_session_id
      t.string :stripe_payment_intent_id
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end