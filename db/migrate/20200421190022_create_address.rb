class CreateAddress < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :state_province
      t.string :city
      t.string :zip_code
      t.references :chapter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
