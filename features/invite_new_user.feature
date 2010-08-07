@no-txn
Feature: Invite User to Project

  In order to add a user to a project,
  As a project administrator
  I want to send a project invitation to that user

  Background:


  @no-txn @wip
  Scenario: An invite is sent to an non-existent user
    Given a baseline configuration
    And I am logged in as "john@test.com"
    And I am using project "Project One"

    When I send an invitation to "eric@test.com"
    Then a confirmation email is sent to "eric@test.com"
    And an account for "eric@test.com" exists
    And the account for "eric@test.com" is associated with the project "Project One"
    And I see an entry for "eric@test.com" in the Team Member list

#  Scenario: Password Reset action will set user account to activated if it is not yet activated
#
#  @wip
#  Scenario: An invite is sent to an existing user - the user is immediately added to the project
#
#    Given the usºer "eric@test.com" exists
#    When I send an invitation to "eric@test.com"
#    Then the account for "eric@test.com" is associated with the project "Project One"
#    And I see an entry for "eric@test.com" in the Team Member list
#
#  Scenario: An invite is sent to an existing user that is already assigned to the project
#
#  Scenario: Expire pending accounts after 30 days
#
#  Scenario: Confirmation of project invitation
#
#  Scenario: Attempt to subscribe an invalid looking email address.
#
#  Scenario: Handle creation of user errors from the controller and display a message
#
#  Scenario: Bring up the Invite User dialog more than once (a bug keeps it from popping up a second time)
#
#  Scenario: Bad Email Address is detected and ajax request is never made