require 'rails_helper'

feature 'administration user' do

    before(:each) do
        @user = FactoryBot.create(:user, role: 'admin', chapter: nil)
        @user_creted = User.create!(:first_name => 'Test', :last_name => 'Test', :email => 'test@test.com', :password => '123456', :phone_number => '123')
    end

    scenario 'should be redirect to sign in page when access user administration page' do
        visit '/users/new'
        expect(page).to have_content "Sign in"
    end

    scenario 'should access create user page with correct credentials' do
        sign_in(@user.email, @user.password)
        find('#link-users').click
        expect(page).to have_content "Add User"
    end

    scenario 'should access edit user page with correct credentials' do
        sign_in(@user.email, @user.password)
        visit edit_user_path(@user)
        expect(page).to have_content "Edit User"
    end

    scenario 'should show error messages when do not complete information' do
        sign_in(@user.email, @user.password)
        find('#link-users').click
        click_button 'Submit'
        expect(page).to have_content "Email can't be blank"
    end

    scenario 'should create user' do
        sign_in(@user.email, @user.password)
        find('#link-users').click
        fill_in 'user_first_name', with: 'First Name'
        fill_in 'user_last_name', with: 'Last Name'
        fill_in 'user_email', with: 'test1@test.com'
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '123456'
        fill_in 'user_phone_number', with: '987654321'
        click_button 'Submit'
        expect(page).to have_content "The user First Name Last Name was successfully created!"
    end

    scenario 'should edit user' do
        sign_in(@user.email, @user.password)
        visit edit_user_path(@user)
        fill_in 'user_first_name', with: 'First Name Edited'
        click_button 'Submit'
        expect(page).to have_content "The user First Name Edited Last was successfully updated!"
    end

    scenario 'should show error when password and password_confirmation do not be equal' do
        sign_in(@user.email, @user.password)
        visit edit_user_path(@user)
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '12345'
        click_button 'Submit'
        expect(page).to have_content "Password confirmation doesn't match Password"
    end
end