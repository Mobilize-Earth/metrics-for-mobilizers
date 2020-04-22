class StreetSwarmsController < ApplicationController

  def new
    @street_swarm = StreetSwarm.new
    @types = StreetSwarm.options
    authorize! :new, StreetSwarmsController
  end

  def create
    @street_swarm = StreetSwarm.new(
      user_id: current_user.id,
      chapter_id: current_user.chapter.id,
      xr_members_attended: params[:street_swarm][:xr_members_attended]
    )
    if @street_swarm.save
      flash[:success] = "Street Swarm data successfully entered"
      redirect_to street_swarms_path
    else
      flash[:errors] = @street_swarm.errors.full_messages
      @types = StreetSwarm.options
      render "new"
    end
  end
end
