$(function() {
	
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

	function toArray(enum) {
	    return Array.prototype.slice.call(enum);
	}

	Function.prototype.curry = function() {
	    if (arguments.length < 1) {
	        return this; //nothing to curry with - return function
	    }
	    var __method = this;
	    var args = toArray(arguments);
	    return function() {
	        return __method.apply(this, args.concat(toArray(arguments)));
	    }
	}

})
