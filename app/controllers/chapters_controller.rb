class ChaptersController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all
  end

  def new
    @chapter = Chapter.new
    @potential_coordinators = User.where(role: "external", chapter: nil)
  end

  def create
    params_chapter = params[:chapter]

    @chapter = Chapter.new(
      name: params_chapter[:name],
      active_members: params_chapter[:active_members],
      total_subscription_amount: params_chapter[:total_subscription_amount]
    )
    if @chapter.save
      coordinator_ids = params_chapter[:users]

      if coordinator_ids
        coordinator_ids.each do |id|
          user = User.find(id)
          user.update!(chapter: @chapter)
        end
      end

      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to new_chapter_path
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
    @current_coordinators = User.where(role: "external", chapter: @chapter)
    @potential_coordinators = User.where(role: "external", chapter: nil)
  end

  def update
    @chapter = Chapter.find(params[:id])
    @chapter.update(chapter_params)
    if @chapter.valid?
      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to edit_chapter_path(@chapter.id)
    end
  end

  private

  def chapter_params
    params.require(:chapter).permit(:name, :active_members, :total_subscription_amount, :user_id)
  end

  def user_params
    params.require(:chapter).permit(:users)
  end
end
