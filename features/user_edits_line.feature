Feature: User edits line
  Background:
    Given there is a signed in user "marilyn@examle.com" with password "notfoobar"
    And that user has the following line:
     | title      | foo                |
    And I am on that line's page
 
  Scenario: Happy path
    When I click "Edit Line"
    And I fill in "Bar" for "Title"
    And I press "Update Line"
    Then I should be on that line's page
    And I should see the title "Bar" 

  Scenario: Unsuccessful Edit
    When I click "Edit Line"
    And I fill in "" for "Title"
    And I press "Update Line"
    Then I should see "Title can't be blank"

  Scenario: User changes their mind
    When I click "Edit Line"
    And I click "Cancel"
    Then I should be on that line's page
    And I should see the title "foo"
