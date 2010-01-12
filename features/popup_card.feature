As a project memeber, 
I want to be able to popup a card and view/edit the card details from pretty much wherever the card is displayed or referenced in the tool.

@wip
Scenario: Popup the card from the My Tasks page

  Given Baseline Project "simple_project"
  And User Persona "Frank"
  
  When I view "My Tasks"
  And click the popup card link on the first card
  
  Then I should see a the popup dialog for the card
  
@wip
Scenario: Edit Title

  Given Baseline Project "simple_project"
  And User Persona "Frank"
  
  When I view "Project Kanban"
  And click the popup card link on the first card
  And edit the card title with "New Card"
  
  Then the card title is updated on the poup card
  And the card title is updated on the kanban board
  
Scenario: Popup the card from the kanban board

Scenario: Popup the card from the backlog board

Scenario: When a card is popped up, check the details of that card.... (TBD)
