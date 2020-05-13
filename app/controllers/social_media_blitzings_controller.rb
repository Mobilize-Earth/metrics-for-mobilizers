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
            number_of_posts: params[:social_media_blitzing][:number_of_posts],
            number_of_people_posting: params[:social_media_blitzing][:number_of_people_posting],
            identifier: params[:social_media_blitzing][:identifier],
            report_date: report_date
        )
        if @social_media_blitzing.save
            flash[:success] = "Social Media Blitzing data was successfully reported!"
            redirect_to growth_activities_path
        else
            flash[:errors] = @social_media_blitzing.errors.full_messages
            @types = SocialMediaBlitzing.social_media_blitzing_type_options
            redirect_to growth_activities_path(params.permit(:social_media_blitzing_type))
        end
    end
end
