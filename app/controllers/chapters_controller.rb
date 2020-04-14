class ChaptersController < ApplicationController
  def index
    @chapters = Chapter.all
  end

  def new
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.create(params.require(:chapter).permit(:name, :active_members, :total_subscription_amount, :description))

    if @chapter.valid?
      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to new_chapter_path
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    @chapter.update(params.require(:chapter).permit(:name, :active_members, :total_subscription_amount, :description))

    if @chapter.valid?
      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to edit_chapter_path(@chapter.id)
    end
  end
end
