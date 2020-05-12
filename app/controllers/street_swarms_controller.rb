class StreetSwarmsController < ApplicationController

  def new
    @street_swarm = StreetSwarm.new
    @types = StreetSwarm.options
    authorize! :new, StreetSwarmsController
  end

  def create
    date_params = params[:report_date]
    localTime = DateTime.parse(date_params)
    report_date = localTime.beginning_of_week
    @street_swarm = StreetSwarm.new(
      user_id: current_user.id,
      chapter_id: current_user.chapter.id,
      mobilizers_attended: params[:street_swarm][:mobilizers_attended],
      report_date: report_date
    )
    if @street_swarm.save
      flash[:success] = "Street Swarm data successfully entered"
      redirect_to arrestable_actions_path
    else
      flash[:errors] = @street_swarm.errors.full_messages
      @types = StreetSwarm.options
      redirect_to arrestable_actions_path(params.permit(:street_swarm_type))
    end
  end
end
