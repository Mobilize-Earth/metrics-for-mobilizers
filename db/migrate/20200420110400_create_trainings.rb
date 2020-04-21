class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    create_table :training_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :trainings do |t|
      t.integer :number_attendees, default: 0
      t.references :training_types, null: false, foreign_key: true
      t.references :chapter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
