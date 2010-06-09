$(function() {

	$.fn.colorbox_tasklist = function(options) {
		var defaults = {
			card: null,
		};
		var options = $.extend(defaults, options);
		var card = options.card;

		function add_task(parent, task) {
			alert(task.name)
			var html = '';
			html += '<div class="task">';
			html += '<span class="owner">' + task.owner + '</span>';
			html += '<span class="title">' + task.name + '</span>';
			html += '</div>';
			$(parent).append(html);
		}

		for (var i = 0; i < card.tasks.length; i++) {
			var task = card.tasks[i];
			add_task(this, task);
		}

		$('div.task .title', this).editInPlace({
			url: "http://foobar.com/"
		})
		return $(this);

	};

	$.fn.colorbox_card = function(options) {

		var defaults = {
			card: null,
		};
		var options = $.extend(defaults, options);
		var card = options.card;

		function card_description(card) {
			return card.description == null ? "No Description" : card.description;
		}

		// TODO: Refactor and DRY up the notion of a card number to be unique and start with 1 .. in each project
		function card_number(card) {
			return card.id
		}
		
		function card_attribute_updated(attribute_name, value) {
			function update_title(parent, value) {
					parent.find("." + "card_body a").html(card_number(card) + ":" + value)
			}
			if (attribute_name == "title") {
				update_title($('#backlog_card_'+ card.id), value);
				update_title($('#kanban_card_'+ card.id), value);
			} 
		}
		
		var html = ''
		html += '<div class="title">' + card.title + '</div>'
		html += '<h2>Description / Narrative</h2>'
		html += '<div class="description">' + card_description(card) + '</div>'
		html += '<h2>Task List</h2>'
		html += '<div class="tasks">'
		html += '</div>'
		html += '<form class="new_task_form">'

		$(this).html(html)

		$(this).find('div.description').editInPlace({
			field_type: "textarea",
			textarea_cols: 79,
			textarea_rows: 5,
			url: project_card_update_attribute_url(project_id, card.id),
			params: "_method=put&attribute=description",
			success: card_attribute_updated.curry("description")
		})

		$(this).find('div.title').editInPlace({
			field_type: "textarea",
			textarea_cols: 79,
			textarea_rows: 1,
			url: project_card_update_attribute_url(project_id, card.id),
			params: "_method=put&attribute=title",
			success: card_attribute_updated.curry("title")
		})

		$(this).find('.tasks').colorbox_tasklist({
			card: card
		})

		return $(this)

	};

});
