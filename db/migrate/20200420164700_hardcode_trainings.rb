class HardcodeTrainings < ActiveRecord::Migration[6.0]
  def change
    remove_column :trainings, :training_types_id, :integer
    drop_table :training_types
    add_column :trainings, :training_type, :string
  end
end
