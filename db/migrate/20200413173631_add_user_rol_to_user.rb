class AddUserRolToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rol, :integer, default: 3
  end
end
