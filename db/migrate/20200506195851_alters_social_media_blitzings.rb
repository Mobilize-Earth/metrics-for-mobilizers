class AltersSocialMediaBlitzings < ActiveRecord::Migration[6.0]
  def change
    rename_column :social_media_blitzings, :social_media_campaigns, :number_of_posts
    add_column :social_media_blitzings, :number_of_people_posting, :integer
  end
end
