class RenameMobilizationToGrowthActivity < ActiveRecord::Migration[6.0]
  def change
    rename_table :mobilizations, :growth_activities
  end
end
