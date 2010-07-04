$(function() {

  $.fn.colorbox_add_task = function(task) {
	
		var self = this;
		
		function task_owner_changed() {
			var user_id = $(this).val();
		  var card_id = $(this).attr('card_id');
			var task_id = $(this).attr('task_id');
			var url = project_card_task_url(CurrentProject.project_id, card_id, task_id)
			$.post(url, {"task[user_id]":user_id, "authenticity_token":window._auth_token, "_method":"put"});  
		}

		function taskOwnerDropdown(task) {
			var html = '';
			html += '<select task_id="' + task.id + '" card_id="' + task.card_id + '" project_id="' + CurrentProject.project_id +'"" class="task_owner">'
			html += '<option value =""></option>'
			for (var i = 0; i < CurrentProject.users.length; i++) {
				var user = CurrentProject.users[i]
				html += '<option value="' + user.id + '"' + (task.user_id == user.id ? ' selected="selected"' : '') + '>' + user.name + '</option>'
			};
			html += '</select>'
			return html
		}

		function delete_task() {
			function delete_task_callback_success(data, textStatus) {
				$(self).find("task_" + data.id).fadeOut();
			}
		  if (confirm('Are you sure you want to delete this task ?')) {
			  $.post(project_card_task_url(CurrentProject.project_id, task.card_id, task.task_id), {"_method":"delete", "authenticity_token":window._auth_token}, delete_task_callback_success, "json");
		  };
		  return true;
		};

		var html = '';
		html += '<tr id="task_"' + task.id + '" class="task" task_id="' + task.id + '" card_id=' + task.card_id + ' >';
		html += '<td class="owner">' + taskOwnerDropdown(task) + '</td>';
		html += '<td class="name">' + task.name + '</td>';
		html += '<td class="states">' + 'states' + '</td>';
		html += '<td class="actions"><img class="task_delete" src="/images/icons/cog_delete.png" style="cursor: pointer" title="Delete this task"/></td>';

		html += '</tr>';
		$(this).append(html);
		
		$(this).find(".task_owner").bind("change", task_owner_changed)
		$(this).find(".task_delete").click(delete_task.curry(self))
	
	}
	
	$.fn.colorbox_tasklist = function(options) {
		var defaults = {
			users: CurrentProject.users,
		};
		var options = $.extend(defaults, options);
		var card = options.card;

		for (var i = 0; i < card.tasks.length; i++) {
			var task = card.tasks[i];
			$(this).colorbox_add_task(task);
		}

		$('.task td.name', this).each(function(index, element) {
			var task = $(this).parents(".task:first");
			$(this).editInPlace({
				url: project_card_task_update_attribute_url(CurrentProject.project_id, task.attr("card_id"), task.attr("task_id")),
				params: "attribute=name"
			})
		});

		return $(this);
		var url = $.post(url, {
			"task[name]": value,
			"authenticity_token": window._auth_token,
			"_method": "put"
		});

	};

	$.fn.colorbox_card = function(options) {

		var defaults = {
			card: null,
		};
		var options = $.extend(defaults, options);
		var card = options.card;

		var self = this;

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
				update_title($('#backlog_card_' + card.id), value);
				update_title($('#kanban_card_' + card.id), value);
			}
		}

		var html = ''
		html += '<div class="title">' + card.title + '</div>'

		html += '<span class="label">Description / Narrative</span>'
		html += '<div class="description">' + card_description(card) + '</div>'

		html += '<span class="label">Task List</span>'

		html += '<form method="POST" class="create_new_task" action="' + project_card_tasks_url(card.project_id, card.id) + '.json">'
		html += '<input id="authenticity_token" name="authenticity_token" type="hidden" value="' + window._auth_token + '">'
		html += '<input name="task[name]" value="<enter new task>"></input>'
		html += '</form>'
		
		html += '<table class="tasks">'
		html += '</table>'

		$(this).html(html)

		// Setup the new task form/input to be an ajax action
		$(this).find('form.create_new_task input').clearOnFocus()
		$(this).find('form.create_new_task').ajaxForm({
			dataType: 'json',
			success: function(json) {
				$(self).find('.tasks').colorbox_add_task(json)
			}
		})

		$(this).find('.description').editInPlace({
			field_type: "textarea",
			textarea_cols: 79,
			textarea_rows: 5,
			url: project_card_update_attribute_url(project_id, card.id),
			params: "_method=put&attribute=description",
			success: card_attribute_updated.curry("description")
		})

		$(this).find('.title').editInPlace({
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
