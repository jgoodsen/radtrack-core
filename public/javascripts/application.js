function mouse_over_pointer(e) {
	$(this).css("cursor", "pointer");
}

$.fn.clearOnFocus = function() {
	return this.focus(function() {
		var v = $(this).val();
		$(this).val(v === this.defaultValue ? '' : v);
	}).blur(function() {
		var v = $(this).val();
		$(this).val(v.match(/^\s+$|^$/) ? this.defaultValue : v);
	});
};

function toArray(enum_local) {
    return Array.prototype.slice.call(enum_local);
}

Function.prototype.curry = function() {
    if (arguments.length < 1) {
        return this; //nothing to curry with - return function
    }
    var __method = this;
    var args = toArray(arguments);
    return function() {
        return __method.apply(this, args.concat(toArray(arguments)));
    };
};

function is() {
  var browser = {
    ie: Boolean(document.all),
    ie6: !window.XMLHttpRequest,
    opera: Boolean(window.opera),
    chrome: Boolean(window.chrome),
    firefox: Boolean(window.sidebar),
    webkit: navigator.userAgent.indexOf('AppleWebKit/') > -1  
  };
  return browser;
}

function supported_browsers(){
  return (is().chrome || is().firefox || is().webkit);
}

function browser_warning() {
  if(!supported_browsers()) {
    popup = $('#jquery_dialog_card');
    popup.html("You are using an unsupported browser and may not render radtrack pages correctly, therefore it is recommended that you update it. For modern browser choices try <a href=”http://http://www.google.com/chrome”>Google Chrome</a> or <a href='http://www.mozilla.com/en-US/firefox/firefox.html'>Mozilla Firefox</a>.");
    popup.colorbox({opacity: 0.3});
    popup.show();
  }
}

