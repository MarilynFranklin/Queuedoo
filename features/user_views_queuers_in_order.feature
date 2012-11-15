Feature: User views queuers in order
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has two queuers

  Scenario: all queuers are unprocessed
    When I am on that line's page
    Then I should see the queue in order

  Scenario: user processes a queuer
    When I am on that line's page
    And I click "Process"
    Then I should see the queue reordered
