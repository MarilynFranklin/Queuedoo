Feature: User views queuers in order

  Scenario: all queuers are unprocessed
    Given 1 line
    And that line has two queuers
    When I am on that line's page
    Then I should see the queue in order

  Scenario: user processes a queuer
    Given 1 line
    And that line has two queuers
    When I am on that line's page
    And I click "Process"
    Then show me the page
    # Then I should see the queue reordered
