Feature: Invite User to Project

  In order to add a user to a project,
  As a project administrator
  I want to send a project invitation to that user
  
  # Scenario: Main Success
  # 
  #   Given I'm the user "admin" using project "simple"
  #   And the user "joe" does not exist
  #   
  #   When I send "joe" a project invitation
  #   
  #   Then an invitation email is sent with a confirmation link
  #   And the user "joe" is a member of project "simple" with status "invitation sent"
  # 
  #   When "joe" clicks the invitation link
  #   And enters a valid password
  #   
  #   Then the user "joe" is a member of the "simple" project with status "active"
  # 
  # Scenario: User already exists - present a dialog to add the user directly to the project
  # 
  #   Given I'm the user "admin" using project "simple"
  #   And the user "joe" exists
  # 
  #   When I send "joe" a project invitation
  #   And I confirm the dialog to add "joe" directly to the project
  #   
  #   And the user "joe" is a member of the "simple" project with status "active"
