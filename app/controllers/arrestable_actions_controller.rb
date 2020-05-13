class ArrestableActionsController < ApplicationController

    def new
        @arrestable_action = ArrestableAction.new
        @street_swarm = StreetSwarm.new
        @types = ArrestableAction.options
        authorize! :new, ArrestableActionsController
    end

    def create
      date_params = params[:report_date]
      localTime = DateTime.parse(date_params)
      report_date = localTime.beginning_of_week
        @arrestable_action = ArrestableAction.new(
            user_id: current_user.id,
            chapter_id: current_user.chapter.id,
            type_arrestable_action: params[:type_arrestable_action],
            mobilizers: params[:arrestable_action][:mobilizers],
            not_mobilizers: params[:arrestable_action][:not_mobilizers],
            trained_arrestable_present: params[:arrestable_action][:trained_arrestable_present],
            arrested: params[:arrestable_action][:arrested],
            days_event_lasted: params[:arrestable_action][:days_event_lasted],
            report_comment: params[:arrestable_action][:report_comment],
            identifier: params[:arrestable_action][:identifier],
            report_date: report_date
        )
        if @arrestable_action.save
            flash[:success] = "Arrestable Action data successfully reported"
            redirect_to arrestable_actions_path
        else
            flash[:errors] = @arrestable_action.errors.messages.values.flatten
            @types = ArrestableAction.options
            redirect_to arrestable_actions_path(params.permit(:type_arrestable_action))
        end
    end
end
