class ChaptersController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all
  end

  def new
    @chapter = Chapter.new
    @coordinators = User.where(role: "external")
  end

  def create
    @chapter = Chapter.new(chapter_params)
    if @chapter.save
      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to new_chapter_path
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
    @coordinators = User.where(role: "external")
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
end
