class AddReportDateToStreetSwarm < ActiveRecord::Migration[6.0]
  def change
    add_column :street_swarms, :report_date, :datetime
  end
end
