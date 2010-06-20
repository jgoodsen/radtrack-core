function mouse_over_pointer(e) {
	$(this).css("cursor", "pointer");
}

$.fn.clearOnFocus = function() {
    return this.focus(function() {
        var v = $(this).val();
        $(this).val( v === this.defaultValue ? '' : v );
    }).blur(function(){
        var v = $(this).val();
        $(this).val( v.match(/^\s+$|^$/) ? this.defaultValue : v );
    });
};

// This function isolates the logic on creating the html id for a card 
function make_card_id(id, prefix) {
    if (typeof prefix == "undefined") {
      prefix = "card_";
    }
	return prefix + id;
}

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
    firefox: Boolean(window.sidebar)
  };
  return browser;
}

function browser_warning() {
  if(!is().chrome && !is().firefox) {
    popup = $('#jquery_dialog_card');
    popup.dialog('warning');
    popup.html("You appear to be using an obsolete browser and may not display correctly on modern websites, therefore it is recommended that you update it. For modern browser choices try <a href=”http://http://www.google.com/chrome”>Google Chrome</a> or <a href='http://www.mozilla.com/en-US/firefox/firefox.html'>Mozilla Firefox</a>.");

    popup.dialog({
      minWidth: 460,
      width: 460,
      close: function(event, ui) { $('#jquery_dialog_card').dialog('warning'); }
    }).dialog('open').fadeIn("slow");
  }
}
