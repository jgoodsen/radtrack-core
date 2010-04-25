// // TODO: not DRY - remove the parm project_id and get it from the card
// function make_card_html(project_id, card) {
// var card_display = '<div style="background-color:#F4D7B6; float: left; width: 100%; padding-bottom: 2px; font-size: .9em;">';
//    card_display += '<div style="padding:0 0 0.5em 0;">';
//       card_display += '<div style="padding:0.5em;background-color:#F2BC8F;">';
//         card_display += '<img src="/images/icons/tasklist-16x16.png" id="cardtasklist-target-' + card.id + '" class="tooltip" title="Task List"/>';
//         card_display += '<img src="/images/icons/move_card_to_backlog.png" id="cardpreamble-target-' + card.id + '" class="remove_from_kanban" title="Move Card to Backlog" style="width: 16px; height: 16px;" />';
//         // card_display += '<img src="/images/icons/comments.png" id="card_comments-target-' + card.id + '" class="tooltip" title="Comments" />';
//         // card_display += '<img src="/images/icons/giftbox-16x16.png" id="cardacceptancetests-target-' + card.id + '" class="tooltip" title="Acceptance Tests" />';
//         card_display += '<img src="/images/icons/cog_delete.png" title="Delete this card" class="delete_card" style="float:right; margin-left: 6px;"/>';
//         card_display += '<img src="/images/icons/spinner.gif" title="Loading card ..." class="spinner" style="float:right; margin-left: 6px; display: none;"/>';
//         card_display += '<span style="float:right; margin-top: 0px;">'+ CardOwnerWidget.display(card) +'</span><br />';
//         card_display += '</div>';
//       card_display += '<div style="padding:1em;margin-left:-0.6em;">'
//        card_display += '<a href="' + project_card_url(project_id, card.id) + '" class="popup_card_link">' + card.id + ': ' + card.title + '</a>';
//       card_display += '</div>'
//     card_display += '</div>';
//  card_display += '</div>';
//  card_display += tooltip_content(card);
//   return card_display;
// }

$(function() {
	
	$.fn.kanban = function(options) {
		var defaults = {
			cards:[],
			card_states: card_states,
		};
		var options = $.extend(defaults, options);

		var div = '';
		
		for (var j=0; j < options.card_states.length; j++) {
			card_state = options.card_states[j].card_state;
			wip_limit_indicator = card_state.wip_limit == 0 ? "" : ' (' + card_state.wip_limit + ')';
			ul = $('<ul id="card_state_' + card_state.id + '" class="kanban_swimlane" style="float: left; width:' + (85/(options.card_states.length)) + '%;"/>');
			ul.append('<li class="header">' + card_state.name + wip_limit_indicator + '</li>');
      	for(var i=0; i < options.cards.length; i++) {

        var card = options.cards[i].card;
        if (card.card_state_id == card_state.id) {
          ul.kanban_card({
            card:card, 
            tasklist_popup: false,
            description_popup: false,
						display_go_back: true,
            display_cardowner: true,
            card_tag: 'li',
            id_prefix: 'kanban_card_',
            position: 'relative'
          });
        }
      };

			$(this).append(ul);

			$('.kanban_swimlane').sortable(
			{
				items: '.kanban_card',
				connectWith: '.kanban_swimlane',
				stop: CardDragged,
			});	
			
		};
		
		$(this).fadeIn(2000);
  
	function CardDragged(x, ui) {
      var card_id = $(ui.item).attr('id').replace(/[^\d]+/g, '');
	    var sibling_cards = $(ui.item).siblings('.kanban_card');
      var position = ui.item.prevAll().length;
      var card_state = ui.item.parent().attr("id");
      var to_cards = $('#'+card_state).sortable("serialize");
      $.post(project_kanban_card_dropped_path(project_id), {
        'authenticity_token':window._auth_token,
        'card_id': card_id,
        'position': position,
        'card_state': card_state,
        'cards': to_cards
       });
       $(ui.item).fadeIn();
	  };

    CardOwnerWidget.setup_events(this);
	
	  return $(this);
	} //end of kanban scope

	$.fn.card_state = function(options) {
		
	}; // end of card_state()


});

