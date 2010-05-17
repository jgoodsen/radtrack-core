$(function() {

	
	$.fn.colorbox_tasklist = function(options) {
      var defaults = {
          card: null,
      };
      var options = $.extend(defaults, options);
	    var card = options.card;
	
			function add_task(parent, task) {
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
				url:"http://foobar.com/"
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
			return card.descriptoin == null ? "No Description" : card.description;
		}
		
			var html = '';
			html += '<h1>' + card.title + '</h1>' ;
			html += '<h2>Description / Narrative</h2>';
			html += '<div class="description">'  + card_description(card)  + '</div>';

				html += '<h2>Task List</h2>';
				html += '<div class="tasks">';
				html += '</div>';

		  $(this).html(html);
		  $(this).find('.description').editInPlace({
				field_type:"textarea",
				textarea_cols: 79,
				textarea_rows: 5,
			  url: "http://com.examplesite.www/users",
			  params: "name=david"
			});
			
			$(this).find('.tasks').colorbox_tasklist({card:card});
			
			
			return $(this);

	};

	
});
