Feature: Email Spec in Rails 4 App

In order to prevent me from shipping a defective email_spec gem
As a email_spec dev
I want to verify that the example rails 4 app runs all of it's features as expected

  Scenario: generators test
    Given the rails4 app is setup with the latest generators
    When I run "bundle exec rails g email_spec:steps" in the rails4 app
    Then the rails4 app should have the email steps in place

  Scenario: regression test
    Given the rails4 app is setup with the latest email steps
    When I run "bundle exec rake db:migrate RAILS_ENV=test" in the rails4 app
    And I run "bundle exec cucumber features -q --no-color" in the rails4 app
    Then I should see the following summary report:
    """
    15 scenarios (7 failed, 8 passed)
    136 steps (7 failed, 1 skipped, 128 passed)
    """

   When I run "bundle exec rake spec RAILS_ENV=test" in the rails4 app
   Then I should see the following summary report:
   """
   11 examples, 0 failures
   """

   When I run "bundle exec rake test RAILS_ENV=test" in the rails4 app
   Then I should see the following summary report:
   """
   8 runs, 8 assertions, 0 failures, 0 errors, 0 skips
   """
