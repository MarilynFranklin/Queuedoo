Feature: User dequeues queuer
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has two queuers
    And I am on that line's page

  Scenario: user processes the first person in line
    When I click "Process"
    Then I should not see "John"
    And I should see "Processed"
    And I should see "Mary"
    When "+16154444444" opens the text message
    Then I should see "It's your turn!" in the text message body

  Scenario: user processes the last person in line
    When I click "Process"
    Then I should not see "John"
    When I click "Process"
    Then I should not see "Mary"
    And "+15555555555" should receive no text messages
