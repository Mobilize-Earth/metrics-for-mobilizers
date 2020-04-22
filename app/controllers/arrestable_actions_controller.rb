class ArrestableActionsController < ApplicationController

    def new
        @arrestable_action = ArrestableAction.new
        @types = ArrestableAction.options
        authorize! :new, ArrestableActionsController
    end
    
    def create
        @arrestable_action = ArrestableAction.new(
            user_id: current_user.id,
            type_arrestable_action: params[:type_arrestable_action],
            chapter_id: current_user.chapter.id,
            xra_members: params[:arrestable_action][:xra_members],
            xra_not_members: params[:arrestable_action][:xra_not_members],
            trained_arrestable_present: params[:arrestable_action][:trained_arrestable_present],
            arrested: params[:arrestable_action][:arrested],
            days_event_lasted: params[:arrestable_action][:days_event_lasted],
            report_comment: params[:arrestable_action][:report_comment]
        )
        if @arrestable_action.save
            flash[:success] = "Arrestable Action data successfully entered"
            redirect_to arrestable_actions_path
        else
            flash[:errors] = @arrestable_action.errors.full_messages
            @types = ArrestableAction.options
            render "new"
        end
    end
end
