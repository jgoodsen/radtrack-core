$(function() {

  $.fn.colorbox_add_task_row = function(task) {
	
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

		function task_state_select(task) {
			var html = '<select id="task_state_' + task.id + '" class="task_state">';
			for (var i=0; i < task_states.length; i++) {
				task_state = task_states[i];
				html += '<option value="' + task_state.id + '"';		
				if (task_state.id == task.task_state_id) {
					html += ' "selected=\"selected\"';
				}
				html += '>' + task_state.name + '</option>';
			}	  
			html += '</select>';
			return html;
		}

		function task_state_changed(task) {
			var task_state_id = $(this).val()
			var url = project_card_task_url(CurrentProject.project_id, task.card_id, task.id)
			$.post(url, {"task[task_state_id]":task_state_id, "authenticity_token":window._auth_token, "_method":"put"});  
		};

		function delete_task() {
			function delete_task_callback_success(data, textStatus) {
				$(self).find("#task_" + data.id).fadeOut();
			}
		  if (confirm('Are you sure you want to delete this task ?')) {
			  $.post(project_card_task_url(CurrentProject.project_id, task.card_id, task.id), {"_method":"delete", "authenticity_token":window._auth_token}, delete_task_callback_success, "json");
		  };
		  return true;
		};

		var html = '';
		html += '<tr id="task_' + task.id + '" class="task" task_id="' + task.id + '" card_id=' + task.card_id + ' >';
		html += '<td class="owner">' + taskOwnerDropdown(task) + '</td>';
		html += '<td class="name">' + task.name + '</td>';
		html += '<td class="states">' + task_state_select(task) + '</td>';
		html += '<td class="actions"><img class="task_delete" src="/images/icons/cog_delete.png" style="cursor: pointer" title="Delete this task"/></td>';

		html += '</tr>';
		$(this).find('table').append(html);
		
		$(this).find(".task_owner").bind("change", task_owner_changed)
		$(this).find("#task_" + task.id + " .task_delete").click(delete_task)
		$(this).find('.task_state').bind("change", task_state_changed.curry(task));
	
	}
	
	$.fn.colorbox_tasklist_table = function(options) {
		var defaults = {
			users: CurrentProject.users,
			tasks: []
		};
		var options = $.extend(defaults, options);
		var tasks = options.tasks;

		for (var i = 0; i < tasks.length; i++) {
			var task = tasks[i];
			$(this).colorbox_add_task_row(task);
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

		html += '<div class="label">Description / Narrative</div>'
		html += '<div class="description">' + card_description(card) + '</div>'

		html += '<div class="tasks" style="overflow:auto;">'
		html += '<table>'

		html += '<tr><td><span>Task List</span></td><td colspan="3">'
		html += '<span><form method="POST" class="create_new_task" action="' + project_card_tasks_url(card.project_id, card.id) + '.json">'
		html += '<input id="authenticity_token" name="authenticity_token" type="hidden" value="' + window._auth_token + '">'
		html += '<input name="task[name]" value="... To Create a Task, Enter the New Task Name Here ..."></input>'
		html += '</form></span>'
		html += '</td></tr>'

		html += '<tr><td class="task_owner label">Who</td><td class="label name">Name</td><td class="label">State</td><td></td></tr>'

		html += '</table>'
		html += '</div>'

		$(this).html(html)

		// Setup the new task form/input to be an ajax action
		$(this).find('form.create_new_task input').clearOnFocus()
		$(this).find('form.create_new_task').ajaxForm({
			dataType: 'json',
			success: function(json) {
				$(self).find('.tasks').colorbox_add_task_row(json)
				$(self).find('form.create_new_task input').val("")
			}
		})

		$(this).find('.description').editInPlace({
			field_type: "textarea",
			cols: 132,
			rows: 3,
			url: project_card_update_attribute_url(project_id, card.id),
			params: "_method=put&attribute=description",
			success: card_attribute_updated.curry("description")
		})

		// $(this).find('.title').titleEditor({
		// 	
		// })
		$(this).find('.title').editInPlace({
			url: project_card_update_attribute_url(project_id, card.id),
			params: "_method=put&attribute=title",
			style:"inherit",
			success: card_attribute_updated.curry("title")
		})

		$(this).find('.tasks').colorbox_tasklist_table({
			tasks: card.tasks
		})

		return $(this)

	};

});
