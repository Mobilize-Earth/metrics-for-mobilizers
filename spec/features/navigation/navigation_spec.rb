require 'rails_helper'

feature 'page access' do
  scenario 'should not access to admin dashboard with invalid credentials' do
    @user = FactoryBot.create(:administrator)
    sign_in('', '')
    expect(page).to have_content "Log In"
  end
end

# feature 'navigation as reviewer' do
#   before(:each) do
#     @user = FactoryBot.create(:reviewer)
#     sign_in(@user.email, @user.password)
#     visit_home_page
#   end
#
#   scenario 'homepage should be reports' do
#     expect(page).to have_content 'Global'
#   end
# end