Feature: User dequeues queuer
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has the following queuers:
      | name | phone        |
      | John | 555-555-5555 |
      | Mary | 555-555-5554 |
    And I am on that line's page

  Scenario: happy path
    When I click "Process"
    Then I should not see "John"
    And I should see "Processed"
    And I should see "Mary"
