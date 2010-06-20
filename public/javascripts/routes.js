//
// All of the url/path methods below are designed to mimick rails named routes methods
//
function projects_url() {
	return "http://" + DOMAIN_AND_PORT + "/projects/"
}

function project_url(project_id) {
	return projects_url() + project_id
}

function project_ajax_iteration_card_dropped_path(project_id) {
	return  project_url(project_id) + "/ajax_iteration_card_dropped";	
}

function project_kanban_card_dropped_path(project_id) {
	return project_url(project_id) + "/card_dropped";	
}

function project_cards_url(project_id) {
	return project_url(project_id) + "/cards";	
}

function project_card_url(project_id, card_id) {
	return project_url(project_id) + "/cards/" + card_id;
}

function project_card_update_attribute_url(project_id, card_id) {
	return project_card_url(project_id, card_id)  + "/update_attribute";
}

function project_card_backlog_card_drop_url(project_id, card_id) {
  return project_card_url(project_id, card_id) + "/backlog_card_drop"
} 

function project_card_move_to_backlog_url(project_id, card_id) {
  return project_card_url(project_id, card_id) + "/move_to_backlog"
}

function project_user_url(project_id, user_id) {
	return project_url(project_id) + "/users/" + user_id;
}

function delete_task_url(project_id, card_id, task_id) {
	return project_card_url(project_id, card_id) + "/tasks/" + task_id;
}

function project_card_task_update_attribute_url(project_id, card_id, task_id) {
	return project_card_url(project_id, card_id) + "/tasks/" + task_id + "/update_attribute"
}

function project_card_state_url(project_id, card_state_id) {
	return project_url(project_id) + "/card_states/" + card_state_id;
}

function project_card_state_dropped_path(project_id, card_state_id) {
	return project_url(project_id) + "/card_states/" + card_state_id + "/dropped";
}

function project_card_activate_url(project_id, card_id) {
	return project_url(project_id) + "/cards/" + card_id + "/activate";
}

function project_invite_user_url(project_id) {
  return project_url(project_id) + "/invite_user/"
	
}

function project_board_reset_card_positions_url(project_id, board_name) {
		return project_url(project_id) + "/boards/" + board_name + "/reset_card_positions"
}

function admin_remove_user_from_project_url(project_id, user_id) { 
  return "http://" + DOMAIN_AND_PORT + "/admin/projects/" + project_id + "/remove_user/" + user_id
}
