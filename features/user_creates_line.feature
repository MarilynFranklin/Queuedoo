Feature: User Creates Line
  As a User
  In order to organize an event
  I want to create a line
  Scenario: Happy path
    Given I am on the homepage
    And I click "Create Line"
    When I fill in "Great Title" for "Title"
    When I fill in "11/25/2004 10:30AM" for "Start time"
    When I fill in "12/25/2004 10:30AM" for "End time"
    And I press "Create"
    Then I should see "Your line has been created"
    And I should see "Great Title"
    #    And I should see "11/25/2004 10:30AM"
    #    And I should see "12/25/2004 10:30AM"

  Scenario: User Attempts to skip title
    Given I am on the homepage
    And I click "Create Line"
    When I fill in "" for "Title"
    When I fill in "11/25/2004 10:30AM" for "Start"
    When I fill in "12/25/2004 10:30AM" for "End"
    And I press "Create"
    Then I should not see "Your line has been created"
    And I should see "Title can't be blank"
    And I should see "" in the "Title" field
    And I should see "11/25/2004 10:30AM" in the "Start time" field
    And I should see "12/25/2004 10:30AM" in the "End time" field
