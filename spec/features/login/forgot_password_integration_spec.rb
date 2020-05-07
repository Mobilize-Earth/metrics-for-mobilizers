require 'rails_helper'

feature 'forgot password', :devise do
  before :each do
    @user = FactoryBot.create(:user)
    visit_sign_in_page
  end

  it "sends email for forgot password" do
    click_link "Forgot your password?"

    fill_in 'user_email', with: @user.email

    click_button "Email me a recovery link"

    email_content = UserMailer.deliveries[0].body.encoded
    expect(email_content).to have_content('Change my password')
    #expect(email_content).to include '<a href="http://localhost:3000/users/password/edit">Change my password</a>'
    #expect(email_content).to include '<img alt="MOBILIZE EARTH" src="data:image/png;base64,'  # Followed by long base64 content
  end
end