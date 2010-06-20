$(function() {

	$.fn.backlog = function(options) {

		var defaults = {
			project_id: 0,
			cards: [],
			card_positions: []
		};
		var options = $.extend(defaults, options);

		var card_positions = options.card_positions;

		self.enableLivesearch = function() {

			var backlog_cards = '.kanban_backlog_card'

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



		function getCardPosition(id) {
			for (var i = 0; i < card_positions.length; i++) {
				if (card_positions[i].id == id) {
					return card_positions[i].position
				}
			};
			return {
				"top": "",
				"left": ""
			};
		}

		for (var i = 0; i < options.cards.length; i++) {
			var card = options.cards[i];
			if (card.card_state_id == null) {
				ul.kanban_card({
					card: card,
					card_tag: 'li',
					id_prefix: 'backlog_card_',
					tasklist_popup: false,
					description_popup: false,
					display_cardowner: true,
					display_go_back: false,
					card_class: 'kanban_backlog_card',
					position: getCardPosition(card.id)
				});
			}
		};

		board.append(ul);

		$('.kanban_card', ul).draggable({
			containment: '#backlog',
			items: '.kanban_card',
			stop: function(data, ui) {

				var self = this;
				var card_id = $(this).attr("card_id");
				var project_id = $(this).attr("project_id");

				var position = $(this).position()

				if ($(self).css("position") == "relative") {
					$(self).css("top", position.top + "px")
					$(self).css("left", position.left + "px")
					alert($(self).css("position") + ", " + $(self).attr("id") + ", " + position.left + ", " + position.top)
					$(this).css("position", "absolute")
				}
				// First go through each card and make sure it has the right positioning and set it's absolute original position
				$('.kanban_backlog_card').each(function(index, element) {
					var x = $(element);
					var pos = x.position()
					// x.css("left", pos.left + "px")
					// 	x.css("top", pos.top + "px")
					// 	x.css("left", pos.left + "px")
					// 	x.css("top", pos.top + "px")
					if ($(self).css("position") == "relative") {
						x.css("top", pos.top + 2 + "px")
						x.css("left", pos.left + 2 + "px")
					}
				})
				$('.kanban_backlog_card').css("position", "absolute")

				alert("Need to save ALL card positions, not just the card that was moved, in order to handle switching from rel to abs positioning")
				$.post(
				project_card_backlog_card_drop_url(project_id, card_id), {
					"authenticity_token": window._auth_token,
					"left": position.left,
					"top": position.top
				},
				function(data, textStatus) {
					//$(self).effect("bounce", { times:2 }, 300);
					// $(self).css("position", "relative")
				},
				"json");
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
				project_card_activate_url(project_id, card_id), {
					"authenticity_token": window._auth_token
				},
				function(data, textStatus) {
					$(ui.draggable).hide("puff", {},
					500).remove();
				},
				"json");
			}
		});

		for (var i = 0; i < card_positions.length; i++) {
			var pos = card_positions[i]
			var card = $('#backlog_card_' + pos.id);
			card.css("position", "absolute")
			card.css("top", pos.position.top + "px")
			card.css("left", pos.position.left + "px")
		};

		return $(this);



		function kanban_backlog_resize() {
			var w = $(window);
			var H = w.height();
			var W = w.width();
			$('.kanban_backlog').css({
				width: W - 360
			});
		};

		kanban_backlog_resize();
		$(window).wresize(kanban_backlog_resize);
	};

});
