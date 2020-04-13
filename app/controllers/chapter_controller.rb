class ChapterController < ApplicationController
  def new
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.create(params.require(:chapter).permit(:name, :active_members, :total_subscription_amount, :description))
    if @chapter.valid?
      redirect_to admin_index_path
    else
      flash[:errors] = @chapter.errors.full_messages
      redirect_to chapter_new_path
    end
  end
end
