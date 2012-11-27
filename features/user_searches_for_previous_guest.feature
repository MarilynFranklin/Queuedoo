Feature: User searches for previous guest

  Scenario: User successfully adds a previous guest to the line
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that user's line has two queuers
    And I am on that line's page
    And I click "Process"
    When I press "Previous Guest"
    Then I should see "Enter phone number:"
    When I fill in "+15555555555" for "look_up"
    And I click "Look Up"
    And I should see "John Phone: +15555555555"
    When I click "Add To Line"
    Then I should see "2 John"
    And I should see "John has been added to the line"
    And I should not see "Look Up"

  Scenario: User enters phone number in another format
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that user's line has two queuers
    And I am on that line's page
    And I click "Process"
    When I press "Previous Guest"
    Then I should see "Enter phone number:"
    When I fill in "555-555-5555" for "look_up"
    And I click "Look Up"
    And I should see "John Phone: +15555555555"
    When I click "Add To Line"
    Then I should see "2 John"
    And I should see "John has been added to the line"
    And I should not see "Look Up"

  Scenario: User enters phone number that isn't in database
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And I am on that line's page
    When I press "Previous Guest"
    Then I should see "Enter phone number:"
    When I fill in "555-555-5555" for "look_up"
    And I click "Look Up"
    And I should see "Could not find a previous guest with that number"
    And I should not see "Add To Line"

  Scenario: User enters phone number for a guest that doesn't belong to the user
    Given 1 line
    And that line has two queuers
    And there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And I am on that line's page
    When I press "Previous Guest"
    Then I should see "Enter phone number:"
    When I fill in "555-555-5555" for "look_up"
    And I click "Look Up"
    And I should see "Could not find a previous guest with that number"
    And I should not see "Add To Line"
