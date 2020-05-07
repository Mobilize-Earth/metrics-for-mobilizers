class SocialMediaBlitzing < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    def self.social_media_blitzing_type_options
        ['Social Media Blitzing']
    end

    validates :number_of_posts, :number_of_people_posting,
        numericality:{
            only_integer: true,
            :greater_than => 0,
            less_than_or_equal_to: 1_000_000_000
        }

    validates :user,
        :chapter,
        presence: true

    def self.to_csv
        attributes = %w{chapter_name coordinator_email number_of_posts number_of_people_posting report_date created_at}

        CSV.generate(headers: true) do |csv|
            csv << attributes

            all.includes(:chapter, :user).find_each do |m|
                csv << [m.chapter.name, m.user.email, m.number_of_posts, m.number_of_people_posting, m.report_date, m.created_at]
            end
        end
    end
end
