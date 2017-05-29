if (typeof jQuery !== 'undefined') {
    (function($) {
         document.addEventListener("DOMContentLoaded", function(event) { 
            var table = $('#trackingTbl').DataTable();
            var info = table.page.info();
            var pageNext = document.getElementsByClassName("paginate_button next");
            var pagePrev = document.getElementsByClassName("paginate_button previous");
            pagePrev[0].style.display="none";
            if (info.pages == 1)
                pageNext[0].style.display="none";

        });
         function updateNextPrevious()
        {
            var table = $('#trackingTbl').DataTable();
            var info = table.page.info();
            var pageNext = document.getElementsByClassName("paginate_button next");
            var pagePrev = document.getElementsByClassName("paginate_button previous");
            
            if (info.page == info.pages-1) 
                pageNext[0].style.display="none";
            
            if (info.page == 0) 
                pagePrev[0].style.display="none";
            else
                pagePrev[0].style.display="";

            if (info.pages == 1) {
                pagePrev[0].style.display="none";
                pageNext[0].style.display="none";
            }
        }

     $(document).ready(function() {
    	$('#trackingTbl').DataTable({
    		responsive: true,
            "iDisplayLength": 10,
            "aLengthMenu": [[10, 20, 50, -1], [10, 20, 50, "All"]],
            "pagingType": "simple_numbers",
            "dom": '<"top">rt<"bottom"ilp><"clear">',
            "columnDefs" : [{"width": "20%", "targets": 0}, {"width": "5%", "targets": 1}, {"width": "5%", "targets": 2}, {"type":"date-eu", 
            					"targets": 2}, {"width": "5%", "targets": 3}, {"width": "10%", "targets": 4}],
            "order": [[ 3, 'asc' ], [ 2, 'desc' ], [ 6, 'desc' ]]
        });

        

        $('#trackingTbl').on('draw.dt', function () {
            updateNextPrevious();
        } );

        
    } );
 })(jQuery);
}