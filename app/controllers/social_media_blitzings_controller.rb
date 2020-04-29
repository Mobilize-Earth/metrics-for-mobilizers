class SocialMediaBlitzingsController < ApplicationController

    def new
        @types = SocialMediaBlitzing.social_media_blitzing_type_options
        @social_media_blitzing = SocialMediaBlitzing.new
        authorize! :new, SocialMediaBlitzingsController
    end

    def create
        @social_media_blitzing = SocialMediaBlitzing.new(
            user_id: current_user.id,
            chapter_id: current_user.chapter.id,
            social_media_campaigns: params[:social_media_blitzing][:social_media_campaigns],
            did_social_media_blitzing: params[:social_media_blitzing][:did_social_media_blitzing]
        )
        if @social_media_blitzing.did_social_media_blitzing == "false"
            @social_media_blitzing.social_media_campaigns = 0
        end
        if @social_media_blitzing.save
            flash[:success] = "Social Media Blitzing data was successfully reported!"
            redirect_to social_media_blitzings_path
        else
            flash[:errors] = @social_media_blitzing.errors.full_messages
            @types = SocialMediaBlitzing.social_media_blitzing_type_options
            render "new"
        end
    end
end