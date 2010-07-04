// TODO: This was extracted from inline HTML - it needs some tests and en should be a jQuery plugin

	function add_team_member(user, pending) {
		$('#invite_user_working').hide();
		
		var html = "";
		html += '<div id="user_' + user.id + '" class="user project_user">';
		html += '<h1>' + user.email;
		html += '<img title="Remove this user from the project?" style="cursor: pointer; float: right;" src="/images/icons/cog_delete.png" id="project_user_'+ user.id + '" class="project_user_delete" alt="Cog_delete">';
		html += '</h1>';
		if (pending) {
			html += '<h2>(Invitation Pending)</h2>';
		}
		html += '</div>'
		$('#project_users').append($(html).project_user());
	}
	
	function popup_invite_user_dialog() {
		$('#invite_user_dialog').dialog({title:"Invite a Person to this Project"});
		$('#invite_user_dialog').dialog("open");
	}
	
	function showInvitingUserWorking(){ 
		$('#invite_user_form').hide();
		$('#invite_user_working').show();
	}
	
	$(function() {
		$('#invite_user_button').click(function() {
			popup_invite_user_dialog();
		})
		
		// setup jQuery Plugin 'ajaxForm'
	    var options = {
	        dataType:  'json',
			beforeSubmit: showInvitingUserWorking,
	        success: function(json) {
				$('#invite_user_dialog').dialog("close");
				add_team_member(json, true);
	        }
		};
		
		$('#invite_user_dialog form').ajaxForm(options);
	});
