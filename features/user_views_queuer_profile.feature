Feature: User views queuer profile
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has the following queuer:
      | name  | John Smith   |
      | phone | 555-555-5555 |
    And that queuer belongs to the user

  Scenario: Successful
    And I am on that line's page
    When I click "John Smith"
    Then I should be on that queuer's page
    And I should see "John Smith"
    And I should see "555-555-5555"

  Scenario: linking to/from queuer show page
    And I am on that queuer's page
    When I click "View Line"
    Then I should be on that line's page
    And I should see "John Smith"
    And I should not see "555-555-5555"
