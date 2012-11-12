@wip
Feature: User views queuer profile

  Scenario: Successful
    Given 1 line
    And that line has the following queuer:
      | name  | John Smith   |
      | phone | 555-555-5555 |
    And I am on that line's page
    When I click "John Smith"
    Then I should be on that queuer's page
    And I should see "John Smith"
    And I should see "555-555-5555"
