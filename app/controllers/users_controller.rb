class UsersController < ApplicationController

    def new
        authorize! :new, UsersController
        @user = User.new
    end

    def create
        @user = User.create(params.require(:user).permit(:first_name, :last_name, :email, :password, :role, :password_confirmation, :phone_number, :chapter_id))

        if @user.valid?
          flash[:success] = "The user #{@user.first_name} #{@user.last_name} was successfully created!"
          # Mailer spike 
          # UserMailer.welcome_email(@user).deliver_now
          redirect_to admins_index_path
        else
          flash[:errors] = @user.errors.full_messages
          render new_user_path
        end
    end

    def edit
      authorize! :edit, UsersController
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        @user.update(params.require(:user).permit(:first_name, :last_name, :email, :role, :phone_number, :chapter_id))
      else
        @user.update(params.require(:user).permit(:first_name, :last_name, :email, :password, :role, :password_confirmation, :phone_number, :chapter_id))
      end
      if @user.valid?
        flash[:success] = "The user #{@user.first_name} #{@user.last_name} was successfully updated!"
        redirect_to admins_index_path
      else
        flash[:errors] = @user.errors.full_messages
        redirect_to edit_user_path(@user.id)
      end
    end
end
