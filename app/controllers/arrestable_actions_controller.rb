class ArrestableActionsController < ApplicationController

    def new
        @arrestable_action = create_arrestable_action
        @street_swarm = create_street_swarm
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
            redirect_to arrestable_actions_path(type_arrestable_action: params[:type_arrestable_action], last_arrestable: params[:arrestable_action].to_json)
        end
    end

    private
    def create_street_swarm
        street_swarm_created = StreetSwarm.new
        street_swarm_created.from_json(params[:last_swarm]) unless params[:last_swarm].blank?
        street_swarm_created
    end

    private
    def create_arrestable_action
        arrestable_action_created = ArrestableAction.new
        arrestable_action_created.from_json(params[:last_arrestable]) unless params[:last_arrestable].blank?
        arrestable_action_created
    end
end
