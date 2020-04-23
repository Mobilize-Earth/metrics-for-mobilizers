class CreateMobilizations < ActiveRecord::Migration[6.0]
  def change
    create_table :mobilizations do |t|
      t.string :type_mobilization
      t.integer :participants, default: 0
      t.integer :new_members_sign_ons, default: 0
      t.integer :total_one_time_donations, default: 0
      t.integer :xra_donation_suscriptions, default: 0
      t.integer :arrestable_pledges, default: 0
      t.integer :xra_newsletter_sign_ups, default: 0
      t.references :chapter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end