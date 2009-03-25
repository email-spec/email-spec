Feature: EmailSpec Example -- Prevent Bots from creating accounts

In order to help alleviate email testing in apps
As an email-spec contributor I want new users of the library
to easily adopt email-spec in their app by following this example

In order to prevent bots from setting up new accounts
As a site manager I want new users
to verify their email address with a confirmation link

Scenario: A new person signs up imperatively 
    Given I am a real person wanting to sign up for an account
    And I am at "/"

    When I fill in "Email" with "quentin@example.com"
    And I fill in "Name" with "Quentin Jones"
    And I press "Sign up"

    Then "quentin@example.com" should receive 1 email
    And "quentin@example.com" should have 1 email
    And "foo@bar.com" should not receive an email

    When "quentin@example.com" opens the email with subject "Account confirmation"

    Then I should see "confirm" in the email
    And I should see "Quentin Jones" in the email
    And I should see "Account confirmation" in the subject

    When I follow "Click here to confirm your account!" in the email
    Then I should see "Confirm your new account"


Scenario: slightly more declarative, but still mostly imperative
    Given I am a real person wanting to sign up for an account
    And I'm on the signup page

    When I fill in "Email" with "quentin@example.com"
    And I fill in "Name" with "Quentin Jones"
    And I press "Sign up"

    Then I should receive an email

    When I open the email
    Then I should see "Account confirmation" in the subject

    When I follow "http:///confirm" in the email
    Then I should see "Confirm your new account"


 Scenario: declarative
    Given I am a real person wanting to sign up for an account
    And I'm on the signup page

    When I submit my registration information
    Then I should receive an email with a link to a confirmation page




