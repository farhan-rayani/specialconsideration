/*
 * Metadata - jQuery function for parsing metadata from elements
 *
 * Author: Chris Dunstall
 * Date: 02-Sep-2016
 */

/**
 * Gives the ability to return metadata stored as an attribute in an element.
 *
 * Given the element:
 * <button type="button" id="myButton" data="{item_id: 1, item_label: 'Label'}" ></button>
 *
 * Usage:
 * var data = $('#myButton').metadata() // returns {item_id: 1, item_label: 'Label'}
 * console.log("item: " + data.item_label);
 *
 */
(function($) {

	$.fn.metadata = function() {
		var elem = this;
		var name = 'data';
		var data = "{}";

		// Ensure data attribute exists
		if (elem.attr(name) != undefined) {
			var attr = elem.attr(name);
			if (attr) {
				data = attr;
			}
		}

		if (data.indexOf('{') < 0) {
			data = "{" + data + "}";
		}

		data = eval("(" + data + ")");

		return data;
	};

})( jQuery );
