module Helpers
    module SessionHelpers
        def sign_in(email, password)
            visit_sign_in_page
            fill_in "Your Email", with: email
            fill_in "Password", with: password
            click_button "Log In"
        end

        def visit_home_page
            Capybara.app_host = "https://reporting.dev.organise.earth/"
            visit "/"
        end

        def visit_sign_in_page
            visit_home_page
            click_link "Log In"
        end
    end
end
