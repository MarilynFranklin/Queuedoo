Feature: User adds Queuer to line
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line

  Scenario: User successfully adds a new guest to the line 
    And I am on that line's page
    Then I should see "Add someone to the line:"
    When I click "New Guest"
    And I fill in "John Smith" for "Name"
    And I fill in "555-555-5555" for "Phone"
    And I press "Add"
    Then I should see "You have added someone to the line"
    And I should be on that line's page
    And I should see "John Smith"

    @wip
  Scenario: User successfully adds a previous guest to the line
    Given that line has two queuers
    And I am on that line's page
    And I click "Process"
    When I press "Previous Guest"
    And I fill in "+15555555555" for "look_up"
    And I click "Look Up"
    And I should see "John Phone: +15555555555"
    When I click "Add To Line"
    And show me the page
    Then I should see "2 John"
    And I should see "John has been added to the line"
    And I should not see "Look Up"

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
