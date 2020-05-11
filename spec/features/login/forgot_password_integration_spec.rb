require 'rails_helper'

feature 'forgot password', :devise do
  before :each do
    @user = FactoryBot.create(:user)
  end

  it "sends email for forgot password" do
    visit_sign_in_page

    click_link "Forgot your password?"

    fill_in 'user_email', with: @user.email

    click_button "Email me a recovery link"

    email_content = get_email_html
    link_url = email_content.xpath("//a")[0][:href]
    img_src = email_content.xpath("//img")[0][:src]

    expect(link_url).to include 'http://localhost:3000/users/password/edit'
    expect(img_src).to include 'data:image/png;base64,'  # Followed by long base64 content
  end

  it "does not reset password when current password is wrong" do
    sign_in(@user.email, @user.password)

    click_on @user.full_name

    click_on "Reset Password"

    fill_in 'user_current_password', with: 'hello1'
    fill_in 'user_password', with: 'hello2'
    fill_in 'user_password_confirmation', with: 'hello2'
    click_button "Save"

    expect(page).to have_content 'Current password is invalid'

    fill_in 'user_current_password', with: 'hello2'
    fill_in 'user_password', with: 'hello3'
    fill_in 'user_password_confirmation', with: 'hello3'
    click_button "Save"

    expect(page).to have_content 'Current password is invalid'
  end

  it "resets password for logged in users" do
    @user = FactoryBot.create(:user, password: 'hello1', password_confirmation: 'hello1', role: 'reviewer')
    sign_in(@user.email, @user.password)

    click_on @user.full_name

    click_on "Reset Password"

    fill_in 'user_current_password', with: 'hello1'
    fill_in 'user_password', with: 'hello2'
    fill_in 'user_password_confirmation', with: 'hello2'
    click_button "Save"

    expect(page).to have_content 'Global'
  end
end

def get_email_html
  Nokogiri::HTML.parse(Devise::Mailer.deliveries[0].body.encoded).document
end