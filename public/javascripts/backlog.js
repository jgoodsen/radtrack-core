$(function() {
  
  $.fn.backlog = function(options) {
	  
    var defaults = {
      project_id: 0,
      cards:[]
    };
    var options = $.extend(defaults, options);

    self.enableLivesearch = function() {
      
      var backlog_cards = '.kanban_backlog li'

      $('input[name="f"]').search(backlog_cards, function(on) {
        on.reset(function() {
          $(this).removeClass("livesearch_empty")
          $('#none').hide();
          $(backlog_cards).show();
        });

        on.empty(function() {
          // $('#none').show();
          $(this).addClass("livesearch_empty")
          $(backlog_cards).hide();
        });

        on.results(function(results) {
          $(this).removeClass("livesearch_empty")
          $('#none').hide();
          $(backlog_cards).hide(); //hide all
          results.show(); //show only resulting elements
        });
      });  
          
    }
    enableLivesearch();
    
    self.enableFilterByCardType = function() {
      $('.card_type_filter_icon').click(function() {
        var card_type_id = $(this).attr("card_type_id")
        $(this).toggleClass("card_type_filter_icon_on")
        if ($(this).hasClass("card_type_filter_icon_on")) {
          $('.kanban_backlog .card_type_icon_' + card_type_id).closest(".kanban_card").hide()
        } else {
          $('.kanban_backlog .card_type_icon_' + card_type_id).closest(".kanban_card").show()          
        }
      })
    }
    enableFilterByCardType();
    
    var board = $(this);
    var ul = $('<ul/>').addClass("kanban_backlog");

    for(var i=0; i < options.cards.length; i++) {
      var card = options.cards[i];
      if (card.card_state_id == null) {
        ul.kanban_card({
          card: card, 
          card_tag: 'li',
          id_prefix: 'backlog_card_',
          tasklist_popup: false,
          description_popup: false,
          display_cardowner: true,
          display_go_back: false
        });
      }
    };

    board.append(ul);
    $('.kanban_card', ul).draggable({
	    containment: '#backlog',
      items: '.kanban_card',
      stop: function(data, ui) { 
	
				var position = $(this).position();
				
				var left = position.left;
				var top = position.top;

        var card_id = $(this).attr("card_id");
        var project_id = $(this).attr("project_id");
				
				var self = this;
				
        $.post(
          project_card_backlog_card_drop_url(project_id, card_id), 
          {"authenticity_token":window._auth_token, "left":left, "top":top}, 
          function (data, textStatus) {
						//$(self).effect("bounce", { times:2 }, 300);
						// $(self).css("top", top + "px")
						// $(self).css("left", left + "px")
          }, 
          "json"
        );        
      }
    });
      			
    board.append('<div class="kanban_staging_arrow"><img src="/images/vertical_arrow.gif"/></div>');
    
    queue = $('<div/>').addClass("kanban_swimlane").addClass("kanban_queue").attr("id", "kanban_queue");
    queue.append('<div class="header">Kanban Acceptor</div>')
    queue.append('<div class="header2">(Drag Cards Here Place Them on the Kanban)</div>')
    board.append(queue);

    $("#kanban_queue").droppable({
      drop: function(event, ui) { 
        var card_id = $(ui.draggable).attr("card_id");
        var project_id = $(ui.draggable).attr("project_id");
        $.post(
          project_card_activate_url(project_id, card_id), 
          {"authenticity_token":window._auth_token}, 
          function (data, textStatus) {
            $(ui.draggable).hide("puff", {}, 500).remove();
          }, 
          "json"
        );        
      }
    });

    return $(this);
    
  	function kanban_backlog_resize() {
    	var w = $( window ); 
  		var H = w.height(); 
  		var W = w.width(); 
  		$('.kanban_backlog').css( {width: W-360} ); 
  	};
  	
    kanban_backlog_resize();
  	$( window ).wresize( kanban_backlog_resize ); 
  };

});
