function Project(project_id) {

	var self = this;
	
	this.users = [{id:555}];
	this.project_id = project_id;

	self.init = function() {
		self.ajaxGetUsersForProject();
	}

	this.ajaxGetUsersForProjectCB = function(data, textStatus) {
		self.users = data;
	}

}

Project.prototype.ajaxGetUsersForProject = function() {
	$.get("/projects/" + project_id + "/users", {},
	ajaxGetUsersForProjectCB, "json")
}

$(function() {

	$.fn.project_tout = function(options) {

		var defaults = {};
		var options = $.extend(defaults, options);

		var self = this;



		function delete_project(parent) {
			if (confirm('Are you sure you want to remove this project?')) {
				var project_id = $(this).attr('project_id')
				$.post(project_url(project_id), {
					"_method": "delete",
					"authenticity_token": window._auth_token
				},
				delete_project_callback_success, "json");
			}
			return true;
		}



		function delete_project_callback_success(data, textStatus) {
			return true;
		}
		$('img.project_delete', this).click(delete_project);

	};

	$.fn.project_user = function(options) {

		var defaults = {};
		var options = $.extend(defaults, options);



		function remove_user_from_project() {
			if (confirm('Are you sure you want to remove this user from the project?')) {
				var user_id = $(this).attr('id').replace(/[^\d]+/g, '');
				$.post(
				admin_remove_user_from_project_url(project_id, user_id), {
					"authenticity_token": window._auth_token
				},
				function(date) {
					$('#user_' + user_id).remove()
				},
				"json");
			}
			return true;
		}
		$('img.project_user_delete', this).click(remove_user_from_project);
		return $(this);
	}

	$('#myprojects .project').project_tout();
	$('div.project_user').project_user();
});
