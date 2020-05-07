class AddTotalArrestablePledgesToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column :chapters, :total_arrestable_pledges, :integer
  end
end
