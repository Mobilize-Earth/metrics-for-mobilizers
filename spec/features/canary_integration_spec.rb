require 'rails_helper'

feature "landing page is displayed" do
  scenario "when a user goes to the landing page" do
    Capybara.app_host = "https://reporting.dev.organise.earth/"
    visit '/'
    expect(page).to have_content "Lorem ipsum dolor sit amet"
  end
end
