class ChaptersController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all
  end

  def new
    @chapter = Chapter.new
    @chapter.build_address
    @current_coordinators = User.none
    authorize! :new, ChaptersController
    @countries = CS.get.to_a
    @states = @cities = []
  end

  def create
    @chapter = Chapter.new(chapter_params)
    if @chapter.save
      flash[:success] = "#{@chapter.name} was successfully created!"
      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.messages.values.flatten
      redirect_to new_chapter_path
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
    @chapter.build_address if @chapter.address.blank?
    @current_coordinators = User.where(role: "external", chapter: @chapter)
    authorize! :edit, ChaptersController
    @countries = CS.get.to_a
    chapter_country_code = CS.get.key(@chapter.address.country)
    chapter_state_code = CS.states(chapter_country_code).key(@chapter.address.state_province)
    @states = CS.states(chapter_country_code).to_a
    @cities = CS.cities(chapter_state_code, chapter_country_code)
    @states = [] if @states.blank?
    @cities = [] if @cities.blank?

  end

  def update
    @chapter = Chapter.find(params[:id])
    @chapter.update(chapter_params)

    if @chapter.valid?
      flash[:success] = "#{@chapter.name} was successfully updated!"
      redirect_to admins_index_path
    else
      flash[:errors] = @chapter.errors.messages.values.flatten
      redirect_to edit_chapter_path(@chapter.id)
    end
  end

  def show
    authorize! :show, ChaptersController
    @chapter = Chapter.find(params[:id])
  end


  def current_user_chapter
    redirect_to chapter_path(current_user.chapter)
  end

  def chapter_params
    params.require(:chapter).permit(:name, :active_members, :total_subscription_amount, address_attributes: [:id, :country, :state_province, :city, :zip_code])
  end
end
