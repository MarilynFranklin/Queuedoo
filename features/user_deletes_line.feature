Feature: User deletes line:
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has the following line:
     | title      | foo                |
     | start_time | 11/25/2004 10:30am |
     | end_time   | 12/25/2004 10:30am |
    And I am on that line's page
 
  Scenario: Happy path
    When I click "Delete Line"
    Then I should be on the lines page
    And I should not see "foo"
    And I should not see "10/25/2004 10:30am"
    And I should not see "11/25/2004 10:30am"
    And I should see "Your line has been deleted"
