class MobilizationsController < ApplicationController

    def new
        @mobilization = Mobilization.new
        @types = Mobilization.options
        authorize! :new, MobilizationsController
    end

    def create
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
            xra_newsletter_sign_ups: params[:mobilization][:xra_newsletter_sign_ups]
        )
        if @mobilization.save
            flash[:success] = "Mobilization data successfully entered"
            redirect_to mobilizations_path
        else
            flash[:errors] = @mobilization.errors.full_messages
            @types = Mobilization.options
            render "new"
        end
    end
end
