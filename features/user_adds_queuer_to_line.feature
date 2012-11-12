@wip
Feature: User adds Queuer to line

  Scenario: Successful add
    Given 1 line
    And I am on that line's page
    Then I should see "Add someone to the line"
    When I fill in "John Smith" for "Name"
    And I fill in "555-555-555" for "Phone"
    And I press "Add"
    Then I should see "You have added someone to the line"
    And I should be on that line's page
    And I should see "John Smith"
