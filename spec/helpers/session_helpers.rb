module Helpers
    module SessionHelpers
        def signin(email, password)
            Capybara.app_host = "https://reporting.dev.organise.earth/"
            visit "/"
            click_link "Sign in"
            fill_in "Email", with: email
            fill_in "Password", with: password
            click_button "Log in"
        end
    end
end
  