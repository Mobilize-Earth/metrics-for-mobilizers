class AddRebelsToMobilization < ActiveRecord::Migration[6.0]
  def change
    add_column :mobilizations, :mobilizers_involved, :integer, default: 0
  end
end
