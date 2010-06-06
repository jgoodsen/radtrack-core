//
// This was originally jquery.livesearch.js but I modified it to be case insensitive 
// and renamed the file - John Goodsen. April 21, 2010
//
(function($) {
  
  // Implement a case insensitive jQuery selecgtor operation ":icontains() that is used when matching elements"
  $.expr[':'].icontains = function(obj, index, meta, stack){
  return (obj.textContent || obj.innerText || jQuery(obj).text() || '').toLowerCase().indexOf(meta[3].toLowerCase()) >= 0;
  };
  
  var Search = function(block) {
    this.callbacks = {};
    block(this);
  }

  Search.prototype.all = function(fn) { this.callbacks.all = fn; }
  Search.prototype.reset = function(fn) { this.callbacks.reset = fn; }
  Search.prototype.empty = function(fn) { this.callbacks.empty = fn; }
  Search.prototype.results = function(fn) { this.callbacks.results = fn; }

  function query(selector) {
    if (val = this.val()) {
      return $(selector + ':icontains("' + val + '")');;
    } else {
      return false;
    }
  }

  $.fn.search = function search(selector, block) {
    var search = new Search(block);
    var callbacks = search.callbacks;

    function perform() {
      if (result = query.call($(this), selector)) {
        callbacks.all && callbacks.all.call(this, result);
        var method = result.size() > 0 ? 'results' : 'empty';
        return callbacks[method] && callbacks[method].call(this, result);
      } else {
        callbacks.all && callbacks.all.call(this, $(selector));
        return callbacks.reset && callbacks.reset.call(this);
      };
    }

    $(this).live('keypress', perform);
    $(this).live('keydown', perform);
    $(this).live('keyup', perform);
    $(this).bind('blur', perform);
  }
})(jQuery);
