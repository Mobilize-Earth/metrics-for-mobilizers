class GrowthActivitiesController < ApplicationController

    def new
        @types = GrowthActivity.growth_activity_type_options
        @growth_activity = GrowthActivity.new
        @social_media_blitzing = SocialMediaBlitzing.new
        authorize! :new, GrowthActivitiesController
    end

    def create
      date_params = params[:report_date]
      local_time = DateTime.parse(date_params)
      report_date = local_time.beginning_of_week
        @growth_activity = GrowthActivity.new(
            user_id: current_user.id,
            chapter_id: current_user.chapter.id,
            growth_activity_type: params[:growth_activity_type],
            event_type: params[:growth_activity][:event_type],
            participants: params[:growth_activity][:participants],
            mobilizers_involved: params[:growth_activity][:mobilizers_involved],
            new_mobilizer_sign_ons: params[:growth_activity][:new_mobilizer_sign_ons],
            total_donation_subscriptions: params[:growth_activity][:total_donation_subscriptions],
            total_one_time_donations: params[:growth_activity][:total_one_time_donations],
            donation_subscriptions: params[:growth_activity][:donation_subscriptions],
            arrestable_pledges: params[:growth_activity][:arrestable_pledges],
            newsletter_sign_ups: params[:growth_activity][:newsletter_sign_ups],
            report_date: report_date
        )
        if @growth_activity.save
            flash[:success] = "#{@growth_activity.growth_activity_type} activity was successfully reported!"
            redirect_to growth_activities_path
            chapter = Chapter.find(current_user.chapter.id)
            update_chapter_members(chapter, @growth_activity.new_mobilizer_sign_ons)
            update_chapter_arrestable_pledges(chapter, @growth_activity.arrestable_pledges)
            update_chapter_subscriptions(chapter, @growth_activity.total_donation_subscriptions)
        else
            flash[:errors] = @growth_activity.errors.full_messages
            @types = GrowthActivity.growth_activity_type_options
            redirect_to growth_activities_path(params.permit(:growth_activity_type))
        end
    end

    private
    def update_chapter_members(chapter, new_mobilizer_sign_ons)
      new_total_mobilizers = chapter.total_mobilizers + new_mobilizer_sign_ons
      chapter.update_attribute(:total_mobilizers, new_total_mobilizers)
    end

    def update_chapter_arrestable_pledges(chapter, arrestable_pledges)
      if chapter.total_arrestable_pledges.nil?
        chapter.update_attribute(:total_arrestable_pledges, arrestable_pledges)
      else
        new_arrestable_pledges = chapter.total_arrestable_pledges + arrestable_pledges
        chapter.update_attribute(:total_arrestable_pledges, new_arrestable_pledges)
      end
    end

    def update_chapter_subscriptions(chapter, donation_subscriptions)
      new_donation_subscriptions = chapter.total_subscription_amount + donation_subscriptions
      chapter.update_attribute(:total_subscription_amount, new_donation_subscriptions)
    end
end
