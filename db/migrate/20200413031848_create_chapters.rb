class CreateChapters < ActiveRecord::Migration[6.0]
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :active_members
      t.text :description
      t.decimal :total_subscription_amount

      t.timestamps
    end
  end
end
