module Helpers
    module SessionHelpers
        def singin(email, password)
            visit_singin_page
            fill_in "Email", with: email
            fill_in "Password", with: password
            click_button "Log in"
        end

        def visit_home_page
            Capybara.app_host = "https://reporting.dev.organise.earth/"
            visit "/"
        end

        def visit_singin_page
            visit_home_page
            click_link "Sign in"
        end
    end
end
  