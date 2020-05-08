class UpdateDonationsAndNewsletterToMobilization < ActiveRecord::Migration[6.0]
  def change
    add_column :mobilizations, :total_donation_subscriptions, :decimal, :precision => 10, :scale => 2
    rename_column :mobilizations, :xra_donation_suscriptions, :donation_subscriptions
    rename_column :mobilizations, :xra_newsletter_sign_ups, :newsletter_sign_ups
  end
end
