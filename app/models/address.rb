class Address < ApplicationRecord
  belongs_to :chapter, inverse_of: :address

  validates :country, :zip_code, presence: true
  validates :zip_code, length: { maximum: 15 }

  def self.to_csv
    attributes = %w{chapter_name country state_province city zip_code created_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.includes(:chapter).find_each do |m|
        csv << [m.chapter.name, m.country, m.state_province, m.city, m.zip_code, m.created_at]
      end
    end
  end
end
