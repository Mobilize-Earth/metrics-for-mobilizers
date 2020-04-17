class ChaptersController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all
  end

  def new
    @chapter = Chapter.new
    @current_coordinators = User.none
  end

  def create
    chapter_params = params[:chapter]

    @chapter = Chapter.new(
      name: chapter_params[:name],
      active_members: chapter_params[:active_members],
      total_subscription_amount: chapter_params[:total_subscription_amount]
    )
    if @chapter.save
      coordinator_ids = chapter_params[:users]

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
  end

  def update
    chapter_params = params[:chapter]

    @chapter = Chapter.find(params[:id])
    @chapter.update(
      name: chapter_params[:name],
      active_members: chapter_params[:active_members],
      total_subscription_amount: chapter_params[:total_subscription_amount]
    )

    if @chapter.valid?
      coordinator_ids = chapter_params[:users]

      if coordinator_ids
        coordinator_ids.each do |id|
          user = User.find(id)
          user.update!(chapter: @chapter)
        end
      end

      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to edit_chapter_path(@chapter.id)
    end
  end
end
