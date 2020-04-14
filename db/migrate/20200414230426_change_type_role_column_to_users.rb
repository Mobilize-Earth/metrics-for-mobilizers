class ChangeTypeRoleColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :rol, :integer
    add_column :users, :role, :string, default: 'consumer'
  end
end
