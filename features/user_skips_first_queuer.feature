Feature: User skips first queuer
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has two queuers
    And I am on that line's page

  Scenario: Happy path
    When I click "Skip"
    Then I should see the first two queuers switch places
