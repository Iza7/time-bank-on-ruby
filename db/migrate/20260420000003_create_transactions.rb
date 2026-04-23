class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user,            null: false, foreign_key: true
      t.references :service_request, null: false, foreign_key: true
      t.integer :amount,            null: false
      t.string  :transaction_type,  null: false
      t.string  :description

      t.timestamps
    end
  end
end
