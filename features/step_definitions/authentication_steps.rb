When /^I sign out$/ do
    step %{I click "Sign Out"}
end

Given /^there is a user "(.*?)" with password "(.*?)"$/ do |email, password|
    @user = Fabricate(:user, email: email, password: password, password_confirmation: password)
    @user.confirm!
end

Given /^I am signed in as "(.*?)"$/ do |email|
    @user = Fabricate(:user, email: email)
    sign_in_as @user
end

Given /^I am signed in$/ do
    @user = Fabricate(:user)
    sign_in_as @user
end

def sign_in_as user
    steps %Q{
      Given I am on the homepage
      When I click "Sign In"
      And I fill in "#{user.email}" for "Email"
      And I fill in "password" for "Password"
      And I click "Sign in"
      Then I should see "Signed in successfully."
    }
end
