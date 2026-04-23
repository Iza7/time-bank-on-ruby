class AddDurationToServices < ActiveRecord::Migration[8.1]
  def change
    add_column :services, :duration, :integer, default: 1, null: false
  end
end
