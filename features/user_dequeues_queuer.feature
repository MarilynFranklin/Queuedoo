Feature: User dequeues queuer

@wip
  Scenario: happy path
    Given 1 line
    And that line has the following queuers:
      | name | phone        |
      | John | 555-555-5555 |
      | Mary | 555-555-5554 |
    And I am on that line's page
    When I click "Process"
    Then I should not see "John"
    And I should see "Processed"
