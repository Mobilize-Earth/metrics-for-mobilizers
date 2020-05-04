class AddReportDateToForms < ActiveRecord::Migration[6.0]
  def change
    add_column :mobilizations, :report_date, :datetime
    add_column :trainings, :report_date, :datetime
    add_column :arrestable_actions, :report_date, :datetime
    add_column :social_media_blitzings, :report_date, :datetime
  end
end
