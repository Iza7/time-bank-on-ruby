class AddVisibleToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :visible, :boolean, default: true
  end
end