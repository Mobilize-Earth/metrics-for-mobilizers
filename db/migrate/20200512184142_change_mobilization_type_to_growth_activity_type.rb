class ChangeMobilizationTypeToGrowthActivityType < ActiveRecord::Migration[6.0]
  def change
    rename_column :growth_activities, :mobilization_type, :growth_activity_type
  end
end
