require 'rails_helper'

feature "landing page is displayed" do
  scenario "when a user goes to the landing page" do
    visit_home_page
    expect(page).to have_content "Metrics for Mobilizers"
  end
end
