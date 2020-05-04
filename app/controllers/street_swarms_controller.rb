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
      xr_members_attended: params[:street_swarm][:xr_members_attended],
      report_date: report_date
    )
    if @street_swarm.save
      flash[:success] = "Street Swarm data successfully entered"
      redirect_to street_swarms_path
    else
      flash.now[:errors] = @street_swarm.errors.full_messages
      @types = StreetSwarm.options
      render "new"
    end
  end
end
