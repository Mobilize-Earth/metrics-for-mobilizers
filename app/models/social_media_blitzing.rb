class SocialMediaBlitzing < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    def self.social_media_blitzing_type_options
        ['Social Media Blitzing']
    end

    validates :social_media_campaigns,
        numericality:{
            only_integer: true,
            :greater_than => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates :user,
        :chapter,
        presence: true
end
