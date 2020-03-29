Feature: As an External Coordinator I want to be able to enter chapter data, So that I can report my chapter's activities in order to receive funding

  Scenario: Login (positive)
    Given I am a registered External Coordinator
    When I log in using good credentials
    Then I see my chapter's dashboard

  Scenario: Data entry
    Given I am on the dashboard
    When I select to create a new entry
    Then I can enter and save the entry's data

