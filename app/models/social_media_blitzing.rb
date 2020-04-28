class SocialMediaBlitzing < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    validates :social_media_campaigns,
        numericality:{
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates :user,
        :chapter,
        presence: true
end
