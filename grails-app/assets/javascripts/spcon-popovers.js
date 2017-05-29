if (typeof jQuery !== 'undefined') {
	(function($) {
		$(document).ready(function() {
			// help button popover
			$('.help-btn').popover({html: true, trigger: 'click', container: 'body'});
			$('.help-btn').on('click', function(e) {
				e.preventDefault();
				return true;
			});





		});
	})(jQuery);
}
