if (typeof jQuery !== 'undefined') {
    (function($) {
    	
    	
    $(document).ready(function() {

        var isIE = /*@cc_on!@*/false || !!document.documentMode;
             // Safari 3.0+ "[object HTMLElementConstructor]" 
            var isSafari = /constructor/i.test(window.HTMLElement) || (function (p) { return p.toString() === "[object SafariRemoteNotification]"; })(!window['safari'] || safari.pushNotification);
           
           // Chrome 1+
            var isChrome = !!window.chrome && !!window.chrome.webstore;
            
            if (!isSafari && !isChrome) {
                    $('#browserWarningModal').modal('toggle');
                }

        //$(document).on('click', '#startRequestBtn', function() {
        //    var isIE = /*@cc_on!@*/false || !!document.documentMode;
             // Edge 20+
        //    var isEdge = !isIE && !!window.StyleMedia;
        //    console.log("Click event of startRequestBtn");

        //    if (isIE || isEdge) {
        //            $('#browserWarningModal').modal('toggle');
        //        }
        //    });
        /*$('#continueAppYes').click(function(event) {
            var uri = document.getElementById("uri").value;
            console.log("Routing to "+ window.location + uri);
                document.location = window.location + uri;
            });
        
        $('#continueAppNo').click(function(event) {
                event.preventDefault();
            });
            */
    });
    })(jQuery);
}
