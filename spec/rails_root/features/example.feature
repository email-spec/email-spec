Feature: Email-spec example

In order to help alleviate email testing in apps
As a email-spec contributor I a newcomer
Should be able to easily adopt email-spec in their app by following this example

Scenario: A new person signs up declaratively
      Given I am at "/"
      And no emails have been sent
      When I fill in "Email" with "quentin@example.com"
      And I press "Sign up"
      Then "quentin@example.com" should receive 1 email
      And "quentin@example.com" should have 1 email
      And "foo@bar.com" should not receive an email
      When "quentin@example.com" opens the email with subject "Account confirmation"
      Then I should see "confirm" in the email
      And I should see "Account confirmation" in the subject
      When I follow "confirm" in the email
      Then I should see "Confirm your new account"


Scenario: I sign up imperatively
      Given I am at "/"
      And no emails have been sent
      When I fill in "Email" with "quentin@example.com"
      And I press "Sign up"
      And I should receive an email
      When I open the email
      Then I should see "confirm" in the email
      When I follow "confirm" in the email
      Then I should see "Confirm your new account"



