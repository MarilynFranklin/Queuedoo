Feature: User skips first queuer

  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has two queuers
    And I am on that line's page

  Scenario: first user is skipped
    When I click "Skip"
    Then I should see the first two queuers switch places
    And I should see "Mary has been texted"
    When "+16154444444" opens the text message
    Then I should see "It's your turn!" in the text message body

  Scenario: user can't skip last user
    When I click "Process"
    Then I should not see "Skip"
