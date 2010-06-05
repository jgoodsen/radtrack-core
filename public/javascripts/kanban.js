$(function() {

    $.fn.kanban = function(options) {
        var defaults = {
            cards: [],
            card_states: card_states,
        };
        var options = $.extend(defaults, options);

        var div = '';

        for (var j = 0; j < options.card_states.length; j++) {
            card_state = options.card_states[j];
            wip_limit_indicator = card_state.wip_limit == 0 ? "": ' (' + card_state.wip_limit + ')';
            ul = $('<ul id="card_state_' + card_state.id + '" class="kanban_swimlane" style="float: left; width:' + (85 / (options.card_states.length)) + '%;"/>');
            ul.append('<li class="header">' + card_state.name + wip_limit_indicator + '</li>');
            for (var i = 0; i < options.cards.length; i++) {

                var card = options.cards[i];
                if (card.card_state_id == card_state.id) {
                    ul.kanban_card({
                        card: card,
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
        
				updateWipLimitFeedback();
				
        $(this).fadeIn(2000);

        function CardDragged(x, ui) {
            var card_id = $(ui.item).attr('id').replace(/[^\d]+/g, '');
            var sibling_cards = $(ui.item).siblings('.kanban_card');
            var position = ui.item.prevAll().length;
            var card_state = ui.item.parent().attr("id");
            var to_cards = $('#' + card_state).sortable("serialize");
            $.post(project_kanban_card_dropped_path(project_id), {
                'authenticity_token': window._auth_token,
                'card_id': card_id,
                'position': position,
                'card_state': card_state,
                'cards': to_cards
            });
            $(ui.item).fadeIn();
						updateWipLimitFeedback();
        };

				function updateWipLimitFeedback() {
	        for (var j = 0; j < options.card_states.length; j++) {
            card_state = options.card_states[j];

						$('#' + 'card_state_' + card_state.id).removeClass("wip_limit_exceeded");						
						$('#' + 'card_state_' + card_state.id).removeClass("wip_limit_acheived");						

						var numberOfCards = $('#' + 'card_state_' + card_state.id).find('li.kanban_card').length
						if (card_state.wip_limit > 0) {
							if (card_state.wip_limit < numberOfCards) {
								$('#' + 'card_state_' + card_state.id).addClass("wip_limit_exceeded");
							} else if (card_state.wip_limit == numberOfCards) {
								$('#' + 'card_state_' + card_state.id).addClass("wip_limit_acheived");
							}
						}
					}
				};
				
        CardOwnerWidget.setup_events(this);

        return $(this);


    }
    //end of kanban scope

});

