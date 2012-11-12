Feature: User Views Line 
  
  Scenario: Happy path
    Given the following lines:
     | title | start_time         | end_time           | 
     | Foo   | 11/25/2004 10:30am | 12/25/2004 10:30am |
     | Bar   | 8/25/2004 10:30am  | 9/25/2004 10:30am  |
    When I go to the homepage
    Then I should see the title "Foo"
    #    And I should see the start "11/25/2004 10:30am"
    #    And I should see the end "12/25/2004 10:30am"
    Then I should see the title "Bar"
    #    And I should see the start "8/25/2004 10:30am"
    #    And I should see the end "9/25/2004 10:30am"

  Scenario: Linking to/from line show page 
    Given the following line:
     | title      | foo                |
     | start_time | 11/25/2004 10:30am |
     | end_time   | 12/25/2004 10:30am |
    And I am on the homepage
    And I click "foo"
    Then I should be on that line's page
    When I click "View all lines"
    Then I should be on the homepage
