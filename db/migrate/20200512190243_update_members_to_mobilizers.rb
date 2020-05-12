class UpdateMembersToMobilizers < ActiveRecord::Migration[6.0]
  def change
    rename_column :arrestable_actions, :xra_members, :mobilizers
    rename_column :arrestable_actions, :xra_not_members, :not_mobilizers
    rename_column :street_swarms, :xr_members_attended, :mobilizers_attended
  end
end
