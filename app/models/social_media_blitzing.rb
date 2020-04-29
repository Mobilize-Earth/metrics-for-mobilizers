class SocialMediaBlitzing < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    attr_accessor :did_social_media_blitzing

    def self.social_media_blitzing_type_options
        ['Social Media Blitzing']
    end

    validates :social_media_campaigns,
        numericality:{
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates :user,
        :chapter,
        :did_social_media_blitzing,
        presence: true

    validate :check_number_campaings

    def check_number_campaings
        if did_social_media_blitzing == "true" && social_media_campaigns == 0
            errors.add(:social_media_campaigns, "must be greater than 0")
        end
    end
end
