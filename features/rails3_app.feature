Feature: Email Spec in Rails 3 App

In order to prevent me from shipping a defective email_spec gem
As a email_spec dev
I want to verify that the example rails 3 app runs all of it's features as expected

  Scenario: generators test
    Given the rails3 app is setup with the latest generators
    When I run "bundle exec rails g email_spec:steps" in the rails3 app
    Then the rails3 app should have the email steps in place

  Scenario: regression test
    Given the rails3 app is setup with the latest email steps
    When I run "bundle exec rake db:migrate RAILS_ENV=test" in the rails3 app
    And I run "bundle exec cucumber features -q --no-color" in the rails3 app
    Then I should see the following summary report:
    """
    15 scenarios (7 failed, 8 passed)
    136 steps (7 failed, 1 skipped, 128 passed)
    """

   When I run "bundle exec rake spec RAILS_ENV=test" in the rails3 app
   Then I should see the following summary report:
   """
   9 examples, 0 failures
   """

