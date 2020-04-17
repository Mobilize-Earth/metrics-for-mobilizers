class CreateStreetSwarms < ActiveRecord::Migration[6.0]
  def change
    create_table :street_swarms do |t|
      t.integer :xr_members_attended, default: 0
      t.references :chapter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
