class UpdateRoleToUser < ActiveRecord::Migration[6.0]
  def up
    User.where(role: 'consumer').update_all(role: 'reviewer')
  end
  def down
    User.where(role: 'reviewer').update_all(role: 'consumer')
  end
end
