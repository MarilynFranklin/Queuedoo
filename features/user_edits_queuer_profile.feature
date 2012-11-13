Feature: User edits queuer profile

  Scenario: Successful
    Given 1 line
    And that line has the following queuer:
      | name  | John Smith   |
      | phone | 555-555-5555 |
    And I am on that queuer's page
    When I click "Edit"
    And I fill in "Julie Andrews" for "Name"
    And I fill in "444-444-4444" for "Phone"
    And I press "Update"
    Then I should see "Julie Andrews"
    And I should see "444-444-4444"
    And I should see "Profile has been updated"

  Scenario: Unsuccessful Edit
    Given 1 line
    And that line has the following queuer:
      | name  | John Smith   |
      | phone | 555-555-5555 |
    And I am on that queuer's page
    When I click "Edit"
    And I fill in "" for "Name"
    And I fill in "444-444-4444" for "Phone"
    And I press "Update"
    Then I should see "" in the "Name" field
    And I should see "444-444-4444" in the "Phone" field
    And I should not see "Profile has been updated"
    And I should see "Name can't be blank"

