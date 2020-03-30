require 'rails_helper'

feature "landing page is displayed" do
  scenario "when a user goes to the landing page" do
    visit '/'

    it "shows content" do
      expect(page).to have_content "Yay! You're on Rails!"
    end
  end
end
