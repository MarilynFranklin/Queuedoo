Feature: User Views Line 
  
  Scenario: Signed in user views lines
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has the following lines:
     | title | start_time         | end_time           | 
     | Foo   | 11/25/2004 10:30am | 12/25/2004 10:30am |
     | Bar   | 8/25/2004 10:30am  | 9/25/2004 10:30am  |
    When I click "View Lines"
    Then I should see the title "Foo"
    Then I should see the title "Bar"
    And I should not see "Looks like you don't have any lines yet. Click 'Create Line' to get started!"

  Scenario: Signed out user can't views lines
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has the following lines:
     | title | start_time         | end_time           | 
     | Foo   | 11/25/2004 10:30am | 12/25/2004 10:30am |
     | Bar   | 8/25/2004 10:30am  | 9/25/2004 10:30am  |
    When I sign out
    Then I should not see "View Lines"
    When I go to the lines page
    Then I should not see "Foo"
    Then I should not see "Bar"
    Then I should see "You need to sign in or sign up before continuing."

  Scenario: Linking to/from line show page 
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has the following lines:
     | title | start_time         | end_time           | 
     | Foo   | 11/25/2004 10:30am | 12/25/2004 10:30am |
     | Bar   | 8/25/2004 10:30am  | 9/25/2004 10:30am  |
    When I click "View Lines"
    And I click "Bar"
    Then I should be on that line's page
    Then show me the page
    When I click "View Lines"
    Then I should be on the lines page
