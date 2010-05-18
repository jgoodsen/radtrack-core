/*

A jQuery edit in place plugin

Version 2.1.1

Authors:
	Dave Hauenstein
	Martin Häcker <spamfaenger [at] gmx [dot] de>

Project home:
	http://code.google.com/p/jquery-in-place-editor/

Patches with tests welcomed! For guidance see the tests at </spec/unit/spec.js>. To submit, attach them to the bug tracker.

License:
This source file is subject to the BSD license bundled with this package.
Available online: {@link http://www.opensource.org/licenses/bsd-license.php}
If you did not receive a copy of the license, and are unable to obtain it, 
learn to use a search engine.

*/

(function($){

$.fn.editInPlace = function(options) {
	
	var settings = $.extend({}, $.fn.editInPlace.defaults, options);
	
	assertMandatorySettingsArePresent(settings);
	
	preloadImage(settings.saving_image);
	
	return this.each(function() {
		var dom = $(this);
		// This won't work with live queries as there is no specific element to attach this
		// one way to deal with this could be to store a reference to self and then compare that in click?
		if (dom.data('editInPlace'))
			return; // already an editor here
		dom.data('editInPlace', true);
		
		new InlineEditor(settings, dom).init();
	});
};

/// Switch these through the dictionary argument to $(aSelector).editInPlace(overideOptions)
/// Required Options: Either url or callback, so the editor knows what to do with the edited values.
$.fn.editInPlace.defaults = {
	url:				"", // string: POST URL to send edited content
	bg_over:			"#ffc", // string: background color of hover of unactivated editor
	bg_out:				"transparent", // string: background color on restore from hover
	hover_class:		"",  // string: class added to root element during hover. Will override bg_over and bg_out
	show_buttons:		false, // boolean: will show the buttons: cancel or save; will automatically cancel out the onBlur functionality
	save_button:		'<button class="inplace_save">Save</button>', // string: image button tag to use as “Save” button
	cancel_button:		'<button class="inplace_cancel">Cancel</button>', // string: image button tag to use as “Cancel” button
	params:				"", // string: example: first_name=dave&last_name=hauenstein extra paramters sent via the post request to the server
	field_type:			"text", // string: "text", "textarea", or "select";  The type of form field that will appear on instantiation
	default_text:		"(Click here to add text)", // string: text to show up if the element that has this functionality is empty
	textarea_rows:		10, // integer: set rows attribute of textarea, if field_type is set to textarea
	textarea_cols:		25, // integer: set cols attribute of textarea, if field_type is set to textarea
	select_text:		"Choose new value", // string: default text to show up in select box
	select_options:		"", // string or array: Used if field_type is set to 'select'. Can be comma delimited list of options 'textandValue,text:value', Array of options ['textAndValue', 'text:value'] or array of arrays ['textAndValue', ['text', 'value']]. The last form is especially usefull if your labels or values contain colons)
	saving_text:		"Saving...", // string: text to be used when server is saving information
	saving_image:		"", // string: uses saving text specify an image location instead of text while server is saving
	saving_animation_color: 'transparent', // hex color string, will be the color the pulsing animation during the save pulses to. Note: Only works if jquery-ui is loaded
	value_required:		false, // boolean: if set to true, the element will not be saved unless a value is entered
	element_id:			"element_id", // string: name of parameter holding the id or the editable
	update_value:		"update_value", // string: name of parameter holding the updated/edited value
	original_html:		"original_html", // string: name of parameter holding original_html value of the editable
	save_if_nothing_changed:	false,  // boolean: submit to function or server even if the user did not change anything
	on_blur:			"save", // string: "save" or null; what to do on blur; will be overridden if show_buttons is true
	cancel:				"", // string: if not empty, a jquery selector for elements that will not cause the editor to open even though they are clicked. E.g. if you have extra buttons inside editable fields
	
	// All callbacks will have this set to the DOM node of the editor that triggered the callback
	
	callback:			null, // function: function to be called when editing is complete; cancels ajax submission to the url param. Prototype: function(idOfEditor, enteredText, orinalHTMLContent, settingsParams, callbacks). The function needs to return the value that should be shown in the dom. Returning undefined means cancel and will restore the dom and trigger an error. callbacks is a dictionary with two functions didStartSaving and didEndSaving() that you can use to tell the inline editor that it should start and stop any saving animations it has configured. Parameter idOfEditor is deprecated, use $(this).attr('id') instead
	success:			null, // function: this function gets called if server responds with a success. Prototype: function(newEditorContentString)
	error:				null, // function: this function gets called if server responds with an error. Prototype: function(request)
	error_sink:			function(idOfEditor, errorString) { alert(errorString); }, // function: gets id of the editor and the error. Make sure the editor has an id, or it will just be undefined. If set to null, no error will be reported. Parameter idOfEditor is deprecated, use $(this).attr('id') instead
	preinit:			null, // function: this function gets called after a click on an editable element but before the editor opens. If you return false, the inline editor will not open. Prototype: function(currentDomNode). Parameter currentDomNode is deprecated use $(this) instead.
	postclose:			null // function: this function gets called after the inline editor has closed and all values are updated. Prototype: function(currentDomNode). Parameter currentDomNode is deprecated use $(this) instead.
};


function InlineEditor(settings, dom) {
	this.settings = settings;
	this.dom = dom;
	this.originalHTML = null; // REFACT: rename, not sure what a better name would be though, preEditorHTML, savedHTML
	this.originalText = null; // REFACT: rename.. not sure about the best name yet
	this.didInsertDefaultText = false;
	this.shouldDelayReinit = false;
};

$.extend(InlineEditor.prototype, {
	
	init: function() {
		this.setDefaultTextIfNeccessary();
		this.connectEvents();
	},
	
	reinit: function() {
		if (this.shouldDelayReinit)
			return;
		
		if (this.settings.postclose)
			this.triggerCallback(this.settings.postclose, /* DEPRECATED remove in 3.0 */ this.dom);
		
		this.markEditorAsInactive();
		this.connectEvents();
	},
	
	setDefaultTextIfNeccessary: function() {
		if('' !== this.dom.html())
			return;
		
		this.dom.html(this.settings.default_text);
		this.didInsertDefaultText = true;
	},
	
	connectEvents: function() {
		var that = this;
		this.dom
			.bind('mouseenter.editInPlace', function(){ that.addHoverEffect(); })
			.bind('mouseleave.editInPlace', function(){ that.removeHoverEffect(); })
			.bind('click.editInPlace', function(anEvent){ that.openEditor(anEvent); });
	},
	
	addHoverEffect: function() {
		if (this.settings.hover_class)
			this.dom.addClass(this.settings.hover_class);
		else
			this.dom.css("background-color", this.settings.bg_over);
	},
	
	removeHoverEffect: function() {
		if (this.settings.hover_class)
			this.dom.removeClass(this.settings.hover_class);
		else
			this.dom.css("background-color", this.settings.bg_out);
	},
	
	openEditor: function(anEvent) {
		if ( ! this.shouldOpenEditor(anEvent.target))
			return;
		
		// prevent re-opening the editor when it is already open
		this.dom.unbind('.editInPlace');
		this.removeHoverEffect();
		
		// don't want the default text to show up in the new editor
		this.removeInsertedDefaultTextIfNeccessary();
		// save original text - for cancellation functionality
		this.originalHTML = this.dom.html();
		this.originalText = trim(this.dom.text());
		
		this.workaroundFirefoxBlurBug();
		this.markEditorAsActive();
		this.replaceContentWithEditor();
		this.connectEventsToEditor();
	},
	
	shouldOpenEditor: function(eventTarget) {
		if (this.isClickedObjectCancelled(eventTarget))
			return false;
		
		if (this.settings.preinit)
			return false !== this.triggerCallback(this.settings.preinit, /* DEPRECATED remove in 3.0 */ this.dom);
		
		return true;
	},
	
	removeInsertedDefaultTextIfNeccessary: function() {
		if ( ! this.didInsertDefaultText
			|| this.dom.html() !== this.settings.default_text)
			return;
		
		this.dom.html('');
		this.didInsertDefaultText = false;
	},
	
	isClickedObjectCancelled: function(eventTarget) {
		if ( ! this.settings.cancel)
			return false;
		
		var eventTargetAndParents = $(eventTarget).parents().andSelf();
		var elementsMatchingCancelSelector = eventTargetAndParents.filter(this.settings.cancel);
		return 0 !== elementsMatchingCancelSelector.length;
	},
	
	workaroundFirefoxBlurBug: function() {
		if ( ! $.browser.mozilla)
			return;
		
		// TODO: Opera seems to also have this bug....
		
		// Firefox will forget to send a blur event to an input element when another one is
		// created and selected programmatically. This means that if another inline editor is
		// opened, existing inline editors will _not_ close if they are configured to submit when blurred.
		// This is actually the first time I've written browser specific code for a browser different than IE! Wohoo!
		
		// Using parents() instead document as base to workaround the fact that in the unittests
		// the editor is not a child of window.document but of a document fragment
		this.dom.parents(':last').find('.editInPlace-active :input').blur();
	},
	
	replaceContentWithEditor: function() {
		var buttons_html  = (this.settings.show_buttons) ? this.settings.save_button + ' ' + this.settings.cancel_button : '';
		var editorElement = this.createEditorElement(); // needs to happen before anything is replaced
		/* insert the new in place form after the element they click, then empty out the original element */
		this.dom.html('<form class="inplace_form" style="display: inline; margin: 0; padding: 0;"></form>')
			.find('form')
				.append(editorElement)
				.append(buttons_html);
	},
	
	createEditorElement: function() {
		if (-1 === $.inArray(this.settings.field_type, ['text', 'textarea', 'select']))
			throw "Unknown field_type <fnord>, supported are 'text', 'textarea' and 'select'";
		
		if ("select" === this.settings.field_type)
			return this.createSelectEditor();
		
		var editor = null;
		if ("text" === this.settings.field_type)
			editor = $('<input type="text"' + this.inputNameAndClass() + '/>');
		else if ("textarea" === this.settings.field_type)
			editor = $('<textarea' + this.inputNameAndClass() 
				+ 'rows="' + this.settings.textarea_rows + '" cols="' 
				+ this.settings.textarea_cols + '"></textarea>');
		
		editor.val(this.originalText);
		return editor;
	},
	
	inputNameAndClass: function() {
		return ' name="inplace_value" class="inplace_field" ';
	},
	
	createSelectEditor: function() {
		var editor = $('<select' + this.inputNameAndClass() + '>'
			+	'<option disabled="true" value="">' + this.settings.select_text + '</option>'
			+ '</select>');
		
		var optionsArray = this.settings.select_options;
		if ( ! $.isArray(optionsArray))
			optionsArray = optionsArray.split(',');
			
		for (var i=0; i<optionsArray.length; i++) {
			
			var currentTextAndValue = optionsArray[i];
			if ( ! $.isArray(currentTextAndValue))
				currentTextAndValue = currentTextAndValue.split(':');
			
			var value = trim(currentTextAndValue[1] || currentTextAndValue[0]);
			var text = trim(currentTextAndValue[0]);
			
			var selected = (value == this.originalText) ? 'selected="selected" ' : '';
			var option = $('<option ' + selected + ' ></option>').val(value).text(text);
			editor.append(option);
		}
		return editor;
		
	},
	
	connectEventsToEditor: function() {
		var that = this;
		function cancelEditorAction() {
			that.handleCancelEditor();
			return false; // stop event bubbling
		}
		function saveEditorAction() {
			that.handleSaveEditor();
			return false; // stop event bubbling
		}
		
		var form = this.dom.find("form");
		
		form.find(".inplace_field").focus().select();
		form.find(".inplace_cancel").click(cancelEditorAction);
		form.find(".inplace_save").click(saveEditorAction);
		
		if ( ! this.settings.show_buttons) {
				// TODO: Firefox has a bug where blur is not reliably called when focus is lost 
				//       (for example by another editor appearing)
			if ("save" === this.settings.on_blur)
				form.find(".inplace_field").blur(saveEditorAction);
			else
				form.find(".inplace_field").blur(cancelEditorAction);
			
			// workaround for firefox bug where it won't submit on enter if no button is shown
			if ($.browser.mozilla) {
				form.keyup(function(event) {
					if (13 === event.which)
						saveEditorAction();
				});
			}
		}
		
		// allow canceling with escape
		form.keyup(function(event) {
			if (27 === event.which) // escape
				return cancelEditorAction();
			else if (13 === event.which) // return (webkit and chrome nightlies don't commit otherwise?
				return saveEditorAction();
		});
		
		
		form.submit(saveEditorAction);
	},
	
	handleCancelEditor: function() {
		this.dom.html(this.originalHTML);
		this.reinit();
	},
	
	handleSaveEditor: function() {
		var enteredText = this.dom.find(':input').val();
		
		if (this.isDisabledDefaultSelectChoice()
			|| this.isUnchangedInput(enteredText)) {
			this.handleCancelEditor();
			return;
		}
		
		if (this.didForgetRequiredText(enteredText)) {
			this.handleCancelEditor();
			this.reportError("Error: You must enter a value to save this field");
			return;
		}
		
		this.showSaving();
		
		if (this.settings.callback)
			this.handleSubmitToCallback(enteredText);
		else
			this.handleSubmitToServer(enteredText);
	},
	
	didForgetRequiredText: function(enteredText) {
		return this.settings.value_required 
			&& ("" === enteredText || undefined === enteredText);
	},
	
	isDisabledDefaultSelectChoice: function() {
		return this.dom.find('option').eq(0).is(':selected:disabled');
	},
	
	isUnchangedInput: function(enteredText) {
		return ! this.settings.save_if_nothing_changed
			&& this.originalText === enteredText;
	},
	
	showSaving: function() {
		var saving_message = this.settings.saving_text;
		if("" !== this.settings.saving_image)
			// REFACT: alt should be the configured saving message
			saving_message = '<img src="' + this.settings.saving_image + '" alt="Saving..." />';
		this.dom.html(saving_message);
	},
	
	handleSubmitToCallback: function(enteredText) {
		// REFACT: consider to encode enteredText and originalHTML before giving it to the callback
		this.enableOrDisableAnimationCallbacks(true, false);
		var newHTML = this.triggerCallback(this.settings.callback, /* DEPRECATED remove in 3.0 */ this.id(), enteredText, this.originalHTML, 
			this.settings.params, this.savingAnimationCallbacks());
		
		if (undefined === newHTML) {
			/* failure; put original back */
			this.reportError("Error: Failed to save value: " + enteredText);
			this.dom.html(this.originalHTML);
		}
		else
			this.dom.html(newHTML);
		
		if (this.didCallNoCallbacks()) {
			this.enableOrDisableAnimationCallbacks(false, false);
			this.reinit();
		}
	},
	
	handleSubmitToServer: function(enteredText) {
		var data = this.settings.update_value + '=' + encodeURIComponent(enteredText) 
			+ '&' + this.settings.element_id + '=' + this.dom.attr("id") 
			+ ((this.settings.params) ? '&' + this.settings.params : '')
			+ '&' + this.settings.original_html + '=' + encodeURIComponent(this.originalHTML);
		
		this.enableOrDisableAnimationCallbacks(true, false);
		this.didStartSaving();
		var that = this;
		$.ajax({
			url: that.settings.url,
			type: "POST",
			data: data,
			dataType: "html",
			complete: function(request){
				that.didEndSaving();
			},
			success: function(html){
				var new_text = html || that.settings.default_text;
				
				/* put the newly updated info into the original element */
				that.dom.html(new_text);
				// REFACT: remove dom parameter, already in this, not documented, should be easy to remove
				// REFACT: callback should be able to override what gets put into the DOM
				that.triggerCallback(that.settings.success, html);
			},
			error: function(request) {
				that.dom.html(that.originalHTML); // REFACT: what about a restorePreEditingContent()
				if (that.settings.error)
					// REFACT: remove dom parameter, already in this, not documented, can remove without deprecation
					// REFACT: callback should be able to override what gets entered into the DOM
					that.triggerCallback(that.settings.error, request);
				else
					that.reportError("Failed to save value: " + request.responseText || 'Unspecified Error');
			}
		});
	},
	
	// Utilities .........................................................
	
	triggerCallback: function(aCallback /*, arguments */) {
		if ( ! aCallback)
			return; // callback wasn't specified after all
		
		var callbackArguments = Array.prototype.splice.call(arguments, 1);
		return aCallback.apply(this.dom[0], callbackArguments);
	},
	
	reportError: function(anErrorString) {
		this.triggerCallback(this.settings.error_sink, /* DEPRECATED remove in 3.0 */ this.id(), anErrorString);
	},
	
	// REFACT: this method should go, callbacks should get the dom node itself as an argument
	id: function() {
		return this.dom.attr('id');
	},
	
	markEditorAsActive: function() {
		this.dom.addClass('editInPlace-active');
	},
	
	markEditorAsInactive: function() {
		this.dom.removeClass('editInPlace-active');
	},
	
	// REFACT: consider rename, doesn't deal with animation directly
	savingAnimationCallbacks: function() {
		var that = this;
		return {
			didStartSaving: function() { that.didStartSaving(); },
			didEndSaving: function() { that.didEndSaving(); }
		};
	},
	
	enableOrDisableAnimationCallbacks: function(shouldEnableStart, shouldEnableEnd) {
		this.didStartSaving.enabled = shouldEnableStart;
		this.didEndSaving.enabled = shouldEnableEnd;
	},
	
	didCallNoCallbacks: function() {
		return this.didStartSaving.enabled && ! this.didEndSaving.enabled;
	},
	
	assertCanCall: function(methodName) {
		if ( ! this[methodName].enabled)
			throw new Error('Cannot call ' + methodName + ' now. See documentation for details.');
	},
	
	didStartSaving: function() {
		this.assertCanCall('didStartSaving');
		this.shouldDelayReinit = true;
		this.enableOrDisableAnimationCallbacks(false, true);
		
		this.startSavingAnimation();
	},
	
	didEndSaving: function() {
		this.assertCanCall('didEndSaving');
		this.shouldDelayReinit = false;
		this.enableOrDisableAnimationCallbacks(false, false);
		this.reinit();
		
		this.stopSavingAnimation();
	},
	
	startSavingAnimation: function() {
		var that = this;
		this.dom
			.animate({ backgroundColor: this.settings.saving_animation_color }, 400)
			.animate({ backgroundColor: 'transparent'}, 400, 'swing', function(){
				// In the tests animations are turned off - i.e they happen instantaneously.
				// Hence we need to prevent this from becomming an unbounded recursion.
				setTimeout(function(){ that.startSavingAnimation(); }, 10);
			});
	},
	
	stopSavingAnimation: function() {
		this.dom
			.stop(true)
			.css({backgroundColor: ''});
	},
	
	missingCommaErrorPreventer:''
});



// Private helpers .......................................................

function assertMandatorySettingsArePresent(options) {
	// one of these needs to be non falsy
	if (options.url || options.callback)
		return;
	
	throw new Error("Need to set either url: or callback: option for the inline editor to work.");
}

/* preload the loading icon if it is configured */
function preloadImage(anImageURL) {
	if ('' === anImageURL)
		return;
	
	var loading_image = new Image();
	loading_image.src = anImageURL;
}

function trim(aString) {
	return aString
		.replace(/^\s+/, '')
		.replace(/\s+$/, '');
}

})(jQuery);
