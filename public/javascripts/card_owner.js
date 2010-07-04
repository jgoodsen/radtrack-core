CardOwnerWidget = {
	
	selected_option: function(owner, user) {
		if (owner.id == user.id) return "selected='selected'";
	},

	option: function(card, user) {
		return '<option value="' + user.id + '" ' + CardOwnerWidget.selected_option(card.owner, user) + '>' + user.name + '</option>';
	},

	owner_select_list: function(card) {
		var select = '<select class="card_owner_select" style="display:none;">';
		select += '<option value="unknown"></option>';
		$.each(CurrentProject.users, function() {
			select += CardOwnerWidget.option(card, this);
		});
		select += '</select>';
		return select;
	},

	card_owner: function(card) {
		return "<span class='owner_name' id='owner_name_" + card.id + "' title='Click to change owner'>" + card.owner.name + "</span>";
	},

	done_button: function() {
		return "<button type='button' class='done_button' style='display:none;'>Done</button>";
	},

	display: function(card, users) {
		return CardOwnerWidget.card_owner(card) + CardOwnerWidget.owner_select_list(card, CurrentProject.users) + CardOwnerWidget.done_button();
	},

	setup_events: function(parent) {
		
		$(".owner_name", parent).click(function() {
			$(this).hide();
			$(this).siblings('button').show();
			$(this).siblings('select').show();
			$(this).parent().parent().find('.delete_card').hide();
		});

		$('.owner_name', parent).hover(
		function() {
			$(this).css('cursor', 'pointer');
			$(this).css('background-color', '#F4D7B6');
		},

		function() {
			$(this).css('background-color', '');
			$(this).css('cursor', '');
		});

		$(".card_owner_select", parent).change(function() {
			$.ajax({
				type: "POST",
				url: project_card_url(CurrentProject.project_id, ElementId.card_id($(this))),
				data: "_method=put&card[user_id]=" + $(this).val() + "&project_id=" + ElementId.extract_project_id($(this)) + "&authenticity_token=" + encodeURIComponent(AUTH_TOKEN),
				dataType: 'json',
				beforeSend: function(x) {
					if (x && x.overrideMimeType) {
						x.overrideMimeType("application/j-son;charset=UTF-8");
					}
				},
				success: function(json) {
					$('span#owner_name_' + json.id).text(json.owner.name);
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					console.log("error: " + textStatus);
				},

			});
		});

		$(".done_button", parent).click(function() {
			$(this).hide();
			$(this).siblings('select').hide();
			$(this).siblings('span').show();
			$(this).parent().parent().find('.delete_card').show();
		});
	},
}
