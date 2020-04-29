module Helpers
    module SessionHelpers
        def sign_in(email, password)
            visit_sign_in_page
            fill_in "user_email", with: email
            fill_in "user_password", with: password
            click_button "Log In"
        end

        def visit_home_page
            Capybara.app_host = "http://localhost:3000"
            Capybara.server_host = "localhost"
            Capybara.server_port = "3000"
          
            visit "/"
        end

        def visit_sign_in_page
            visit_home_page
            click_link "Log In"
        end
    end
end
