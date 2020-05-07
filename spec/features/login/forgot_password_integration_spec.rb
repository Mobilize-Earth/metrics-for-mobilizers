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

    email_content = get_email_html
    link_url = email_content.xpath("//a")[0][:href]
    img_src = email_content.xpath("//img")[0][:src]

    expect(link_url).to include 'http://localhost:3000/users/password/edit'
    expect(img_src).to include 'data:image/png;base64,'  # Followed by long base64 content
  end
end

def get_email_html
  Nokogiri::HTML.parse(Devise::Mailer.deliveries[0].body.encoded).document
end