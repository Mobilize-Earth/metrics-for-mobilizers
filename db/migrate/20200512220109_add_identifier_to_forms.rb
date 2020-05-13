class AddIdentifierToForms < ActiveRecord::Migration[6.0]
  def change
    add_column :growth_activities, :identifier, :string, :limit => 50
    add_column :trainings, :identifier, :string, :limit => 50
    add_column :arrestable_actions, :identifier, :string, :limit => 50
    add_column :social_media_blitzings, :identifier, :string, :limit => 50
    add_column :street_swarms, :identifier, :string, :limit => 50
  end
end
