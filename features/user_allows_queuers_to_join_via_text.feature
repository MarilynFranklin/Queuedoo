Feature: User allows queuers to join line through text

  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has 1 line
    And that line has two queuers
    And I am on that line's page

  Scenario: Happy path
    Then I should see "Text to Join: disabled"
    When I click "Enable Text to Join"
    Then I should see "Text to Join: enabled"
    And I should not see "Text to Join: disabled"
    When I click "Disable Text to Join"
    Then I should see "Text to Join: disabled"
    And I should not see "Text to Join: enabled"
