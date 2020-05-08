class TrainingsController < ApplicationController
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def new
    @types = Training.training_type_options
    @training = Training.new
    authorize! :new, TrainingsController
  end

  def create
    date_params = params[:report_date]
    localTime = DateTime.parse(date_params)
    report_date = localTime.beginning_of_week
    @training = Training.new(
      number_attendees: params[:training][:number_attendees],
      training_type: params[:training_type],
      chapter: current_user.chapter,
      user: current_user,
      report_date: report_date
    )

    if @training.save
      TrainingMailer.success_mailer(current_user).deliver_now
      flash[:success] = "#{@training.training_type} training was successfully created!"
      redirect_to trainings_path
    else
      flash.now[:errors] = @training.errors.messages.values.flatten
      @types = Training.training_type_options
      render "new"
    end
  end
end
