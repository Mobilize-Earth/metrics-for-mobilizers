class StreetSwarmsController < ApplicationController
  def new
    @street_swarm = StreetSwarm.new
  end

  def create
    @street_swarm = StreetSwarm.new(
      user_id: current_user,
      chapter_id: current_user.chapter,
      xr_members_attended: params[:xr_members_attended]
    )
    if @street_swarm.save
      flash[:success] = "Street Swarm data successfully entered"
      redirect_to '/'
    else
      flash[:errors] = @street_swarm.errors.full_messages
      redirect_to :back
    end
  end
end
