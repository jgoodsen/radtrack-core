function mouse_over_pointer(e) {
	$(this).css("cursor", "pointer");
};

$.fn.clearOnFocus = function() {
    return this.focus(function() {
        var v = $(this).val();
        $(this).val( v === this.defaultValue ? '' : v );
    }).blur(function(){
        var v = $(this).val();
        $(this).val( v.match(/^\s+$|^$/) ? this.defaultValue : v );
    });
};

function project_ajax_iteration_card_dropped_path(project_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/ajax_iteration_card_dropped";	
}

function project_kanban_card_dropped_path(project_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/card_dropped";	
}

function project_cards_url(project_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/cards";	
}

function project_card_url(project_id, card_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/cards/" + card_id;
}

function project_card_backlog_card_drop_url(project_id, card_id) {
  return project_card_url(project_id, card_id) + "/backlog_card_drop"
} 

function project_card_move_to_backlog_url(project_id, card_id) {
  return project_card_url(project_id, card_id) + "/move_to_backlog"
}

function project_user_url(project_id, user_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/users/" + user_id;
}

function delete_task_url(project_id, card_id, task_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/cards/" + card_id + "/tasks/" + task_id;
}

function project_card_state_url(project_id, card_state_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/card_states/" + card_state_id;
}

function project_card_state_dropped_path(project_id, card_state_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/card_states/" + card_state_id + "/dropped";
}

function project_card_activate_url(project_id, card_id) {
	return "http://" + DOMAIN_AND_PORT + "/projects/" + project_id + "/cards/" + card_id + "/activate";
}

function remove_user_from_project_url(project_id, user_id) { 
  return "http://" + DOMAIN_AND_PORT + "/admin/projects/" + project_id + "/remove_user/" + user_id
}

// This function isolates the logic on creating the html id for a card 
function make_card_id(id, prefix) {
    if (typeof prefix == "undefined") {
      prefix = "card_";
    }
	return prefix + id;
}


$(function() {
	$('#quickcard').clearOnFocus();
});

