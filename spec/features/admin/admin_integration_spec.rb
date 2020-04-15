require 'rails_helper'

feature 'admin user', :devise do
    
    before(:each) do
        @user = FactoryBot.create(:user, role: 'admin')
    end

    scenario 'should redirect to admin dashboard with valid credentials' do
        sign_in(@user.email, @user.password)
        expect(page).to have_content "Navigation"
    end

    scenario 'should redirect to admin dashboard when visit external dashboard' do
        sign_in(@user.email, @user.password)
        visit "/dashboard/index"
        expect(page).to have_content "Navigation"
        expect(page).to have_content "You are not authorized to access this page."
    end

    scenario 'redirected from landing page to admin dashboard' do
        sign_in(@user.email, @user.password)
        visit_home_page
        expect(page).to have_content "Navigation"
    end

    scenario 'should not access to admin dashboard with invalid credentials' do
        sign_in('', '')
        expect(page).to have_content "Log In"
    end

    scenario 'displays chapters by default, toggling between users and chapters', :js => true do
      sign_in(@user.email, @user.password)

      expect(page).to have_content "Navigation"
      
      find('#chapters-nav-link').click
      expect(find('#chapters-nav-link')[:class]).to have_content 'selected'
      expect(find('#users-nav-link')[:class]).to have_no_content 'selected'
      
      find('#users-nav-link').click
      expect(find('#users-nav-link')[:class]).to have_content 'selected'
      expect(find('#chapters-nav-link')[:class]).to have_no_content 'selected'

      find('#chapters-nav-link').click
      expect(find('#chapters-nav-link')[:class]).to have_content 'selected'
      expect(find('#users-nav-link')[:class]).to have_no_content 'selected'
    end

    scenario 'displays chapter information', :js => true do
      sign_in(@user.email, @user.password)
      visit_home_page
      # Expect chapter data
    end

    scenario 'displays user information', :js => true do
      sign_in(@user.email, @user.password)
      visit_home_page
      # Click users-nav-link
      # Expect user data
    end

    scenario 'links to add chapter form', :js => true do
      sign_in(@user.email, @user.password)
      visit_home_page
      # Click chapters add link
      # Expect to be on chapter add page
    end

    scenario 'links to edit chapter form', :js => true do
      sign_in(@user.email, @user.password)
      visit_home_page
      # Click chapters edit link
      # Expect to be on chapter edit page
    end

    scenario 'links to add user form', :js => true do
      sign_in(@user.email, @user.password)
      visit_home_page
      # Click user add link
      # Expect to be on user add page
    end

    scenario 'links to edit user form', :js => true do
      sign_in(@user.email, @user.password)
      visit_home_page
      # Click user edit link
      # Expect to be on user edit page
    end

end
