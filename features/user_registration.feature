Feature:  User Registration

  In order to start using radtrack
  As a potential user
  I want to create my radtrack user account

  Scenario: Main Success - no project invitation

    Given the user 'quentin' does not exist
    When I signup as 'quentin'
    Then I am prompted to create my first project
    When I create the project "quentin's project"
    Then I see the project "quentin's project" on the index page

    When I open project "quentin's project"
    And I add the card "Card One"
    And I drag card "Card One" to the kanban acceptor
    And I select the "Kanban" tab
    Then I see the card "Card One" in swimlane "requested"
