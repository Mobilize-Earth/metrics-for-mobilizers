class ChangeActiveMembersToTotalMobilizers < ActiveRecord::Migration[6.0]
  def change
    rename_column :chapters, :active_members, :total_mobilizers
  end
end
