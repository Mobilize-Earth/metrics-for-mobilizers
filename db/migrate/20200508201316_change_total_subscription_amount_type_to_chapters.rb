class ChangeTotalSubscriptionAmountTypeToChapters < ActiveRecord::Migration[6.0]
  def up
    change_column :chapters, :total_subscription_amount, :decimal, :precision => 10, :scale => 2
  end
  def down
    change_column :chapters, :total_subscription_amount, :decimal, :precision => 10, :scale => 0
  end
end
