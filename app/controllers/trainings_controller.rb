class TrainingsController < ApplicationController
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def new
    @types = [
      'Induction',
      'DNA',
      'H4E',
      'NVDA',
      'Facilitation',
      'How to start a new chapter',
      'Mass mobilization',
      'Oppression & Movement Building']
    @training = Training.new
  end

  def save
    training_params = params[:training]

    @training = Training.new(
      number_attendees: training_params[:number_attendees],
      training_type: training_params[:training_type],
      chapter: current_user.chapter, 
      user: current_user
    )

    if @training.save
      flash[:success] = "#{@training.training_type} Training was successfully created!"
      redirect_to forms_index_path
    else
      p @training.errors.full_messages 
      flash[:errors] = @training.errors.full_messages
      redirect_to forms_index_path
    end
  end
end
