class MobilizationsController < ApplicationController

    def new
        @types = Mobilization.mobilization_type_options
        @mobilization = Mobilization.new
        @social_media_blitzing = SocialMediaBlitzing.new
        authorize! :new, MobilizationsController
    end

    def create
      date_params = params[:report_date]
      local_time = DateTime.parse(date_params)
      report_date = local_time.beginning_of_week
        @mobilization = Mobilization.new(
            user_id: current_user.id,
            chapter_id: current_user.chapter.id,
            mobilization_type: params[:mobilization_type],
            event_type: params[:mobilization][:event_type],
            participants: params[:mobilization][:participants],
            mobilizers_involved: params[:mobilization][:mobilizers_involved],
            new_members_sign_ons: params[:mobilization][:new_members_sign_ons],
            total_donation_subscriptions: params[:mobilization][:total_donation_subscriptions],
            total_one_time_donations: params[:mobilization][:total_one_time_donations],
            donation_subscriptions: params[:mobilization][:donation_subscriptions],
            arrestable_pledges: params[:mobilization][:arrestable_pledges],
            newsletter_sign_ups: params[:mobilization][:newsletter_sign_ups],
            report_date: report_date
        )
        if @mobilization.save
            flash[:success] = "#{@mobilization.mobilization_type} activity was successfully reported!"
            redirect_to mobilizations_path
            chapter = Chapter.find(current_user.chapter.id)
            update_chapter_members(chapter, @mobilization.new_members_sign_ons)
            update_chapter_arrestable_pledges(chapter, @mobilization.arrestable_pledges)
            update_chapter_subscriptions(chapter, @mobilization.total_donation_subscriptions)
        else
            flash[:errors] = @mobilization.errors.full_messages
            @types = Mobilization.mobilization_type_options
            redirect_to mobilizations_path(params.permit(:mobilization_type))
        end
    end

    private
    def update_chapter_members(chapter, new_members_sign_ons)
      new_active_members = chapter.active_members + new_members_sign_ons
      chapter.update_attribute(:active_members, new_active_members)
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
