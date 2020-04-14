class ChangeTypeRoleColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :chapters, :description, :text
  end
end
