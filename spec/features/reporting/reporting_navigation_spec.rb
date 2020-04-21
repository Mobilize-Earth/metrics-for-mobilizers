require 'rails_helper'

feature 'reporting done' do

  before(:each) do
    @user = FactoryBot.create(:user, role: 'external')
    sign_in(@user.email, @user.password)
    visit_home_page
    visit forms_index_path
  end

  scenario 'user redirected to dashboard when clicks done button' do
    click_link 'I\'m done'
    expect(page).to have_current_path chapter_path(@user.chapter), ignore_query: true
  end

  scenario 'tiles should be disabled if use clicks on no new data tile' do
    find('.no-data-tile').click
    page.all('.form-tile').each do |tile|
      expect(tile[:class].include?('disabled')).to be true
    end
  end

end
