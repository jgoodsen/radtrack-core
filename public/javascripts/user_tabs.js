$.fn.UserTabs = function(options) {
	var defaults = {
	       tabs: [{ title:"Sample Tab", url:"http://www.fluidia.org" }]
	   };
	   var options = $.extend(defaults, options);

	var html = '';
    html += '<div id="project-tools-tabs" style="float: left; width: 100%; height: 800px;">';

    html += '<ul>';

	for (var i=0; i < options.tabs.length; i++) {
		var tab = options.tabs[i];
	}

	$(this).tabs({
	});

}
