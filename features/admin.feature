Feature: As an administrator, I want to manage chapters and their users, So that the org can track and fund them

  Scenario: Onboarding of chapters (negative)
    Given I am not authorized to manage chapters
    When I navigate to chapter management
    Then I see an error message

  Scenario: Onboarding of chapters
    Given I am an admin logged in
    When I onboard a chapter
    Then I see it in the chapter list

  Scenario: Deactivate chapter
    Given I am an admin logged in
    When I deactivate a chapter
    Then I see it in the chapter list as deactivated
    And it does not show in any computation or visualization

  Scenario: Populating roles within a chapter
    Given I am an admin logged in
    When I onboard a role to a chapter
    Then I see them under that chapter
    And they receive a welcome email

  Scenario: Removing roles within a chapter
    Given I am an admin logged in
    When I remove a member to a chapter
    Then I they are no longer able to log in as a chapter role

  Scenario: Logging in as a chapter role
    Given I was added to the chapter as a role
    When I log in with proper credentials
    Then I see the options associated with my role
