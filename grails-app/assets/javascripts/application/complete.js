if (typeof jQuery !== 'undefined') {
    (function($) {
        
        if (window.history && window.history.pushState) {

            $(window).on('popstate', function() {
              var hashLocation = location.hash;
              var hashSplit = hashLocation.split("#!/");
              var hashName = hashSplit[1];

              if (hashName !== '') {
                var hash = window.location.hash;
                if (hash === '') {
                   $('#backAppModal').modal('toggle');
                  window.history.pushState('forward', null, './#forward');
                }
              }
            });
            $('#backAppModal').modal('toggle');
            window.history.pushState('forward', null, './#forward');
          }
    	var regex = /^(.+?)(\d+)$/i;

    	 $(document).on('change', ':file', function() {
            var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });
        
    	$(document).ready(function() {

            /*
             * Close button.
             */
            $('#close').click(function(event) {
                document.location = $.getBaseUrl();
            });

    	}); // End Document.ready()

    })(jQuery);
}
