class ChangeNewMembersSignOnsToNewMobilizerSignOns < ActiveRecord::Migration[6.0]
  def change
    rename_column :growth_activities, :new_members_sign_ons, :new_mobilizer_sign_ons
  end
end
