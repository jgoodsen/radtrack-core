// Use this file to require common dependencies or to setup useful test functions.

function fixture(element) {
  $('<div id="fixtures"/>').append(element).appendTo("body");
}

function teardownFixtures() {
  $("#fixtures").remove();
}

// Stub out some common plugins.
jQuery.fn.live = function(){};
jQuery.fn.defaultValue = function(){};

var mock_card = function(options) {
  
  var opts = $.extend({id: 6785, project_id: 426}, options);
  
  return  {
	  "card":
	  {
			"id": opts.id,
	    "status":null,
			"updated_at":"2009-12-18T07:53:21Z",
			"project_id": opts.project_id,
			"point_estimate":0,
			"title":"Delete Card",
			"card_state_id":8,
			"description":null,
			"iteration_id":11,
			"user_id":null,
			"release_id":3,
			"position":0,
			"card_type_id":2,
			"owner": {
				"name":"Owner is unassigned",
				"admin":null,
				"login":null,
				"email":null,
			},
			"owner":
			  {
			    "id":7896,
			    "name":"Mario",
			  },
			"tasks":[
				{
					"name":"Ajax action to remove the card from the board",
					"updated_at":"2009-12-13T23:16:46Z",
					"task_state_id":7,
					"card_id":264,
					"id":294,
					"user_id":6,
					"position":1,
				}
		  ],
		}
	}
};

var mock_card_1 = mock_card(1111)

var mock_cards = [ mock_card(34), mock_card(56) ];

// TODO: This is a hack - need a better way to get the domain/port for posting to AJAX urls
// Since we define it in the root of the document, we need to define it here for testing purposes
var DOMAIN_AND_PORT = "localhost:3000";
