Feature: User adds Queuer to line
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line

  Scenario: User successfully adds a new guest to the line 
    And I am on that line's page
    Then I should see "No one is in line yet! Use the panel to the right to add a guest."
    And I should see "People in line: 0"
    And I should see "Add someone to the line:"
    When I click "New Guest"
    And I fill in "John Smith" for "Name"
    And I fill in "555-555-5555" for "Phone"
    And I press "Add"
    Then I should see "You have added someone to the line"
    And I should not see "No one is in line yet! Use the panel to the right to add a guest."
    And I should see "People in line: 1"
    And I should be on that line's page
    And I should see "John Smith"

  Scenario: Skips name
    And I am on that line's page
    When I click "New Guest"
    And I fill in "" for "Name"
    And I fill in "555-555-5555" for "Phone"
    And I press "Add"
    Then I should see "Name can't be blank"
    And I should see "555-555-5555" in the "Phone" field

  Scenario: User enters non-numeric data for phone number
    And I am on that line's page
    When I click "New Guest"
    And I fill in "Joe" for "Name"
    And I fill in "aslkfsjfk" for "Phone"
    And I press "Add"
    Then I should see "Please enter a valid phone number"
    And I should see "Joe" in the "Name" field

  Scenario: Signed out user can't add queuer
    When I sign out
    And I am on that line's page
    Then I should see "You need to sign in or sign up before continuing."
