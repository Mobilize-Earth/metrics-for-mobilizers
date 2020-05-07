class UsersController < ApplicationController

    def new
        authorize! :new, UsersController
        @user = User.new
    end

    def create
        @user = User.new(
          email: params[:user][:email],
          chapter_id: params[:user][:chapter_id],
          role: params[:user][:role]
        )
        @user.skip_password_validation = true
        if @user.valid?
          invite_valid_user
          flash[:success] = "The user #{@user.email} was successfully invited!"
          redirect_to admins_index_path
        else
          flash.now[:errors] = @user.errors.full_messages
          render "new"
        end
    end

    def invite_valid_user
      @user.skip_invitation = true
      @user.invite!(@current_user)
      @user.invitation_link = accept_invitation_url(@user, :invitation_token => @user.raw_invitation_token)
      UserMailer.welcome_email(@user).deliver_now
    end

    def edit
      authorize! :edit, UsersController
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      @user.assign_attributes(:email => params[:user][:email], :chapter_id => params[:user][:chapter_id], :role => params[:user][:role])
      if @user.valid?
        @user.save
        flash[:success] = "The user #{@user.full_name} was successfully updated!"
        redirect_to admins_index_path
      else
        flash[:errors] = @user.errors.full_messages
        redirect_to edit_user_path(@user.id)
      end
    end
end
