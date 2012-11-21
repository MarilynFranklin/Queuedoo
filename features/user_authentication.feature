Feature: User authentication
  Scenario: Signed out users see appropriate links
    Given I am on the homepage
    Then I should see "Sign In"
    And I should see "Sign Up"
    And I should not see "Sign Out"
  
  Scenario: Signed in users see appropriate links
    Given I am signed in
    And I am on the homepage
    Then I should see "Sign Out"
    And I should not see "Sign In"
    And I should not see "Sign Up"

  Scenario: Signing up
    Given I am on the homepage
    When I click "Sign Up"
    And I fill in "marilyn@example.com" for "Email"
    And I fill in "foobar" for "Password"
    And I fill in "foobar" for "Password confirmation"
    And I click "Sign up"
    Then I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    Then save and open all raw emails
    And "marilyn@example.com" should receive 1 email with subject "Confirmation instructions"
    When I open the email with subject "Confirmation instructions"
    And I click the first link in the email
    Then I should see "Your account was successfully confirmed. You are now signed in."
  
  Scenario: Signing up with non-matching passwords
    Given I am on the homepage
    When I click "Sign Up"
    And I fill in "marilyn@example.com" for "Email"
    And I fill in "foobar" for "Password"
    And I fill in "notfoobar" for "Password confirmation"
    And I click "Sign up"
    Then I should see "Password doesn't match confirmation"
  
  Scenario: Logging in
    Given there is a user "marilyn@example.com" with password "foobar"
    When I go to the homepage
    And I click "Sign In"
    And I fill in "marilyn@example.com" for "Email"
    And I fill in "foobar" for "Password"
    And I click "Sign in"
    Then I should see "Signed in successfully."
  
  Scenario: Logging in with incorrect password
    Given there is a user "marilyn@example.com" with password "notfoobar"
    When I go to the homepage
    And I click "Sign In"
    And I fill in "marilyn@example.com" for "Email"
    And I fill in "foobar" for "Password"
    And I click "Sign in"
    Then I should see "Invalid email or password"
    And I should see "marilyn@example.com" in the "Email" field
  
  Scenario: Logging out
    Given I am signed in
    And I am on the homepage
    When I click "Sign Out"
    Then I should see "Signed out successfully."
