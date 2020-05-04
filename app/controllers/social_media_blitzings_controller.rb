class SocialMediaBlitzingsController < ApplicationController

    def new
        @types = SocialMediaBlitzing.social_media_blitzing_type_options
        @social_media_blitzing = SocialMediaBlitzing.new
        authorize! :new, SocialMediaBlitzingsController
    end

    def create
      date_params = params[:report_date]
      localTime = DateTime.parse(date_params)
      report_date = localTime.beginning_of_week
        @social_media_blitzing = SocialMediaBlitzing.new(
            user_id: current_user.id,
            chapter_id: current_user.chapter.id,
            social_media_campaigns: params[:social_media_blitzing][:social_media_campaigns],
            report_date: report_date
        )
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
