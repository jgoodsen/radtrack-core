When /I open project "(.*)"/ do |project_name|
  @browser.click_and_wait "link=#{project_name}"
end

When /I add the card "(.*)"/ do |card_title|
  @browser.type "quickcard", card_title
  @browser.submit "id=new_card_form"
  @browser.wait_for_page_to_load "10000"
end

When /I drag card "(.*)" to the kanban acceptor/ do |card_title|
  @browser.drag_and_drop_to_object "//div[@id='backlog']/ul/li[1]", "kanban_queue"
end


When /I select the "Kanban" tab/ do
    @browser.click "//div[@id='project_detail_tabs']/ul/li[2]/a/span" 
end

Then /I see the card "Card One" in swimlane "requested"/ do
  @browser.breakpoint
end
