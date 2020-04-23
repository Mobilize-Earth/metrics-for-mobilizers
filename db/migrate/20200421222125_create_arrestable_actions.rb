class CreateArrestableActions < ActiveRecord::Migration[6.0]
  def change
    create_table :arrestable_actions do |t|
      t.string :type_arrestable_action
      t.integer :xra_members, default: 0
      t.integer :xra_not_members, default: 0
      t.integer :trained_arrestable_present, default: 0
      t.integer :arrested, default: 0
      t.integer :days_event_lasted, default: 0
      t.text :report_comment
      t.references :chapter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
