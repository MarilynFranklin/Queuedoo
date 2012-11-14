Feature: User skips first queuer

  Scenario: Happy path
    Given 1 line
    And that line has two queuers
    And I am on that line's page
    Then show me the page
    When I click "Skip"
    Then show me the page
    Then I should see the first two queuers switch places
