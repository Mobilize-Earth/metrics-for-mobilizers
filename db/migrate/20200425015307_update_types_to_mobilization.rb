class UpdateTypesToMobilization < ActiveRecord::Migration[6.0]
  def change
    remove_column :mobilizations, :type_mobilization, :string
    add_column :mobilizations, :mobilization_type, :string
    add_column :mobilizations, :event_type, :string
  end
end
