Feature: Email-spec errors example

In order to help alleviate email testing in apps
As a email-spec contributor I a newcomer
Should be able to easily determine where I have gone wrong
These scenarios should fail with helpful messages

    Scenario: I fail to receive an email
      Given I am at "/"
      And no emails have been sent
      When I fill in "Email" with "quentin@example.com"
      And I press "Sign up"
      And I should receive an email
      When "quentin@example.com" opens the email with subject "no email"

    Scenario: I fail to receive an email with the expected link
      Given I am at "/"
      And no emails have been sent
      When I fill in "Email" with "quentin@example.com"
      And I press "Sign up"
      And I should receive an email
      When I open the email
      When I follow "link that doesn't exist" in the email

    Scenario: I attempt to operate on an email that is not opened
      Given I am at "/"
      And no emails have been sent
      When I fill in "Email" with "quentin@example.com"
      And I press "Sign up"
      And I should receive an email
      When I follow "confirm" in the email

    Scenario: I attempt to check out an unopened email
      Given I am at "/"
      And no emails have been sent
      When I fill in "Email" with "quentin@example.com"
      And I press "Sign up"
      Then I should see "confirm" in the email
      And I should see "Account confirmation" in the subject



