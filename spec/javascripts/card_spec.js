require("spec_helper.js");
require("../../public/javascripts/application.js");
require("../../public/javascripts/card_owner.js");
require("../../public/javascripts/kanban_card.js");
require("../../public/javascripts/backlog.js"); // TODO: Remove this dependency



// TODO: Poor man's mock - I tried the following code, but it never overrode the display() method...
// var myMock = Smoke.Mock();
// var myMockFunction = Smoke.MockFunction();
// myMockFunction = Smoke.MockFunction();
// myMockFunction.should_receive('display').exactly(1, 'times');
// CardOwnerWidget.display = myMockFunction;
//
CardOwnerWidget = {
  display: function(card, users) {
    return "mocked card owner"
  }
}



Screw.Unit(function(){
});
