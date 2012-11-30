Feature: User Creates Line
  As a User
  In order to organize an event
  I want to create a line

  Scenario: Happy path
    Given I am signed in
    And I click "Create Line"
    When I fill in "Great Title" for "Title"
    And I press "Create"
    Then I should see "Your line has been created"
    And I should see "Great Title"

  Scenario: User Attempts to skip title
    Given I am signed in
    And I click "Create Line"
    When I fill in "" for "Title"
    And I press "Create"
    Then I should not see "Your line has been created"
    And I should see "Title can't be blank"
    And I should see "" in the "Title" field

  Scenario: Signed out users see appropriate links
    Given I am on the homepage
    Then I should not see "Create Line"
