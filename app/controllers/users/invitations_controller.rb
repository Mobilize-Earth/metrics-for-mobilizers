class Users::InvitationsController < Devise::InvitationsController

    def edit
        super
        @user = User.find_by_invitation_token(params[:invitation_token], true)
    end
    
end