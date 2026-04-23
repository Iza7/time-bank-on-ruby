class CreateServiceRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :service_requests do |t|
      t.references :service,   null: false, foreign_key: true
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.string :status, default: "pending", null: false

      t.timestamps
    end

    add_index :service_requests, :status
  end
end
