class MobilizationsController < ApplicationController

    def new
        @types = Mobilization.mobilization_type_options
        @mobilization = Mobilization.new
        authorize! :new, MobilizationsController
    end

    def create
      date_params = params[:report_date]
      localTime = DateTime.parse(date_params)
      report_date = localTime.beginning_of_week
        @mobilization = Mobilization.new(
            user_id: current_user.id,
            chapter_id: current_user.chapter.id,
            mobilization_type: params[:mobilization_type],
            event_type: params[:mobilization][:event_type],
            participants: params[:mobilization][:participants],
            new_members_sign_ons: params[:mobilization][:new_members_sign_ons],
            total_one_time_donations: params[:mobilization][:total_one_time_donations],
            xra_donation_suscriptions: params[:mobilization][:xra_donation_suscriptions],
            arrestable_pledges: params[:mobilization][:arrestable_pledges],
            xra_newsletter_sign_ups: params[:mobilization][:xra_newsletter_sign_ups],
            report_date: report_date
        )
        if @mobilization.save
            flash[:success] = "#{@mobilization.mobilization_type} activity was successfully reported!"
            redirect_to mobilizations_path
            update_chapter_members(@mobilization.new_members_sign_ons)
        else
            flash[:errors] = @mobilization.errors.full_messages
            @types = Mobilization.mobilization_type_options
            render "new"
        end
    end

    private
    def update_chapter_members(new_members_sign_ons)
        chapter = Chapter.find(current_user.chapter.id)
        new_active_members = chapter.active_members + new_members_sign_ons
        chapter.update_attribute(:active_members, new_active_members)
    end
end
