require 'rails_helper'

feature "landing page is displayed" do
  scenario "when a user goes to the landing page" do
    visit '/'
    expect(page).to have_content "Climate Movement Reporting Tool"
  end
end
