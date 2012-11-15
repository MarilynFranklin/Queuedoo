Feature: User adds Queuer to line
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And I am on that line's page

  Scenario: Successful add
    Then I should see "Add someone to the line"
    When I fill in "John Smith" for "Name"
    And I fill in "555-555-5555" for "Phone"
    And I press "Add"
    Then I should see "You have added someone to the line"
    And I should be on that line's page
    And I should see "John Smith"

  Scenario: Skips name
    Given 1 line
    And I am on that line's page
    Then I should see "Add someone to the line"
    When I fill in "" for "Name"
    And I fill in "555-555-5555" for "Phone"
    And I press "Add"
    Then I should see "Name can't be blank"
    And I should see "555-555-5555" in the "Phone" field
