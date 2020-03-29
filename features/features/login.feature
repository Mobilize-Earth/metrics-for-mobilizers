Feature: As an External Coordinator I want to be able to use the site, So that I can report my chapter's activities in order to receive funding

  Scenario: Login (positive)
    Given I am a registered user
    When I log in using good credentials
    Then I am logged in to my dashboard page

  Scenario: Login (negative)
    Given I am a registered user
    When I log in with an incorrect password
    Then I see an error message

  Scenario: Login (negative)
    Given I am a registered user
    When I log in with an incorrect username
    Then I see an error message

  Scenario: Logging out
    Given I am logged in
    When I log out
    Then I am logged out and see the login page
    And I see an error when navigating to a protected page

  Scenario: Login blocked when maxed out
    Given I am a registered user with maxed-out login tries
    When I log in
    Then I see an error message

  Scenario: Login unblocked when maxed out
    Given I am a registered user with maxed-out login tries
    When I log in with good credentials after a cool-down period
    Then I am logged in to my dashboard page

  Scenario: Forgot username
    Given I am a registered user
    When I indicate that I have forgotten my username
    Then I am notified of my username through the appropriate channel

  Scenario: Forgot password
    Given I am a registered user
    When I indicate that I have forgotten my password
    Then I am notified of how to reset my password

  Scenario: Password reset
    Given I am a registered user
    When I follow the instructions to reset my password
    Then I can reset my password and am able to log in using the new password
