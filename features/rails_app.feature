Feature: Email Spec in Rails App

In order to prevent me from shipping a defective email_spec gem
As a email_spec dev
I want to verify that the example rails app runs all of it's features as expected

  Scenario: regression test
    Given the example rails app is setup with the latest generators
    When I run "rake db:migrate RAILS_ENV=test"
    And I run "cucumber features -q --no-color"
    Then I should see the following summary report:
    """
    9 scenarios (5 failed, 4 passed)
    75 steps (5 failed, 1 skipped, 69 passed)
    """
