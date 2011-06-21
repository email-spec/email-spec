Feature: Email Spec in Sinatra App

In order to prevent me from shipping a defective email_spec gem
As a email_spec dev
I want to verify that the example sinatra app runs all of it's features as expected

  Scenario: regression test
    Given the sinatra app is setup with the latest email steps
    When I run "bundle exec cucumber features -q --no-color" in the sinatra app
    Then I should see the following summary report:
    """
    12 scenarios (7 failed, 5 passed)
    110 steps (7 failed, 1 skipped, 102 passed)
    """
