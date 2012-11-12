Feature: User edits line
  Background:
    Given the following line:
     | title      | foo                |
     | start_time | 11/25/2004 10:30am |
     | end_time   | 12/25/2004 10:30am |
    And I am on that line's page
 
  Scenario: Happy path
    When I click "Edit Line"
    And I fill in "Bar" for "Title"
    And I fill in "10/25/2004 10:30am" for "Start"
    And I fill in "11/25/2004 10:30am" for "End"
    And I press "Update Line"
    Then I should be on that line's page
    And I should see the title "Bar" 
    #    And I should see the start "10/25/2004 10:30am"
    #    And I should see the end "11/25/2004 10:30am"

  Scenario: Unsuccessful Edit
    When I click "Edit Line"
    And I fill in "" for "Title"
    And I fill in "10/25/2004 10:30am" for "Start"
    And I fill in "11/25/2004 10:30am" for "End"
    And I press "Update Line"
    Then I should see "Title can't be blank"
    #    And I should see the start "10/25/2004 10:30am"
    #    And I should see the end "11/25/2004 10:30am"
