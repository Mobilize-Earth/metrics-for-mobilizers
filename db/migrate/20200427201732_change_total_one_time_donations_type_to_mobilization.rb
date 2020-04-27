class ChangeTotalOneTimeDonationsTypeToMobilization < ActiveRecord::Migration[6.0]
  def up
    change_column :mobilizations, :total_one_time_donations, :decimal, :precision => 10, :scale => 2
  end
  def down
    change_column :mobilizations, :total_one_time_donations, :integer
  end
end
