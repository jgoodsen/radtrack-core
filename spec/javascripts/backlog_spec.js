require("spec_helper.js");
require("../../public/javascripts/application.js");
require("../../public/javascripts/card_owner.js");
require("../../public/javascripts/card.js");
require("../../public/javascripts/backlog.js");

Screw.Unit(function(){
  describe("Backlog", function(){
	
	  before(function(){
      stub(window, "users").and_return([{user:{id: 1,name:'Administrator',admin:true}}]);      
      fixture($('<div id="mybacklog"></div>'));
      $('#mybacklog').Backlog({cards:mock_cards});
	  });

    after(function(){
      $('#mybacklog').empty();
    });
    
		describe("$.Backlog()", function() {

      it("should create a single kanban swimlane", function(){
        expect($('#mybacklog div:first').hasClass("kanban_swimlane")).to(equal, true);
      });

      it("should give the swimlane container the class 'kanban_swimlane'", function(){
        $('#mybacklog').Backlog({cards:mock_cards});
        expect($('#mybacklog div:first').hasClass("kanban_swimlane")).to(equal, true);
        expect($('#mybacklog div:first').children().length).to(equal, 2);
      });
      
      it("should give the first card the class 'kanban_card'", function(){
          expect($('#mybacklog .kanban_card').length).to(equal, 2);
          expect($('#mybacklog div:first .kanban_card:first').hasClass("kanban_card")).to(equal, true);
        });
      
      it("should give the last card the class 'kanban_card'", function(){
        expect($('#mybacklog div:first .kanban_card:last').hasClass("kanban_card")).to(equal, true);
      });
		  
		});

  });
});
