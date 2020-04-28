class CreateSocialMediaBlitzings < ActiveRecord::Migration[6.0]
  def change
    create_table :social_media_blitzings do |t|
      t.integer :social_media_campaigns
      t.references :chapter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
