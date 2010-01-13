require("spec_helper.js");
require("../../public/jquery-ui-1.7.2.custom/js/jquery-1.3.2.min.js");
require("../../public/jquery-ui-1.7.2.custom/js/jquery-ui-1.7.2.custom.min.js");
require("../../public/multidraggable/js/ui.multidraggable.js");
require("../../public/javascripts/application.js");
require("../../public/javascripts/card_owner.js");
require("../../public/javascripts/kanban_card.js");
require("../../public/javascripts/backlog.js");

Screw.Unit(function(){
  describe("Backlog", function(){
	
	  before(function(){
      stub(window, "users").and_return([{user:{id: 1,name:'Administrator',admin:true}}]);      
      fixture($('<div id="mybacklog"></div>'));
      $('#mybacklog').backlog({cards:mock_cards});
	  });

    after(function(){
      $('#mybacklog').empty();
    });
    
		describe("$.backlog()", function() {

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

  describe("Card", function() {
    
	  before(function(){
      fixture($('<div id="myswimlane"></div>'));
	  });
    
    after(function(){
      $('#myswimlane').empty();
    });

    var card_json = {id:5430, project_id:453, owner:{id:1, name:"The Oz" } };

    describe("when generated with addCard()", function(){
    
      describe("it is wrapped in an element that", function(){

        before(function(){
          $('#myswimlane').addCardd({card: card_json});
        });

        it("should append a top level div with the class 'kanban_card'", function(){
          expect($('#myswimlane div:first').hasClass("kanban_card")).to(equal, true);
        });

        it("should have the 'project_id' attribute", function() {
          expect($('#myswimlane div:first').attr("project_id")).to(equal, card_json.project_id);        
        })

        it("should have the 'card_id' attribute", function() {
          expect($('#myswimlane div:first').attr("card_id")).to(equal, card_json.id);        
        })

      });

      describe("the popup task list", function(){
        it("tooltip button should be shown by default", function(){
          var card_json = {id:5430, project_id:453};
          $('#myswimlane').addCard({card: card_json});
          expect($('#cardtasklist-target-' + card_json.id).hasClass("tooltip")).to(equal, true);
        });
        
        it("should not be shown when configured to hide", function(){
          var card_json = {id:5430, project_id:453, popup_tasklist:false};
          expect($('#cardtasklist-target-' + card_json.id).hasClass("tooltip")).to(equal, false);
        });
      });

      describe("the popup description", function(){
        it("tooltip button should be shown by default", function(){
          $('#myswimlane').addCard({card: card_json});
          expect($('#cardpreamble-target-' + 5430).hasClass("tooltip")).to(equal, true);
        });
        
        it("tooltip button should not be shown when configured to hide", function(){
          $('#myswimlane').addCard({card: card_json, popup_description:false});
          expect($('#cardpreamble-target-' + 5430).hasClass("tooltip")).to(equal, false);
        });
      });
       
      describe("delete icon", function(){
        it("should have 'title' attribute for hovering tooltip", function(){
          $('#myswimlane').addCard({card: card_json});
          expect($('#myswimlane .delete_card:first').attr("title")).to(equal, "Delete this card");
        });
      });

      describe("spinner icon", function(){
        it("should be hidden by default", function(){
          $('#myswimlane').addCard({card: card_json});
          expect($('#myswimlane .spinner:first').attr("style")).to(match, "display: none;");
        });
      });

      describe("cardowner component", function(){
        it("has a CardOwnerWidget placed on the card", function(){
          pending();
        });
      });
        
    });
    
  });

});
