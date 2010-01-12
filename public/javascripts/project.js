$(function() {

	$.fn.project_tout = function(options) {
		
		var defaults = {
		};
		var options = $.extend(defaults, options);    
		
		function delete_project() {
		  if (confirm('Are you sure you want to remove this project?')) {
			var user_id = $(this).attr('id').replace(/[^\d]+/g, '');
				$.post(project_user_url(project_id, user_id), {"_method":"delete", "authenticity_token":window._auth_token}, delete_project_callback_success, "json");        
		  }
		  return true;
		}

		function delete_project_callback_success(data, textStatus) {
      		console.log($(this));
			$(this).remove();
		}
		$('img.project_delete', this).click(delete_project);
	
	};
	
	
	$.fn.project_user = function(options) {
		
		var defaults = {
		};
		var options = $.extend(defaults, options);

		function remove_user_from_project() {
		  if (confirm('Are you sure you want to remove this user from the project?')) {
			  var user_id = $(this).attr('id').replace(/[^\d]+/g, '');
        $.post(
          remove_user_from_project_url(project_id, user_id), 
          { "authenticity_token":window._auth_token }, 
          function(date) {$('#user_' + user_id).remove();}, "json"
        );        
		  }
		  return true;
		}

		$('img.project_user_delete', this).click(remove_user_from_project);
	}

	$('#myprojects .project').project_tout();
	$('div.project_user').project_user();
});
