
$(document).ready(function() {
	
	/* Sort by Status for student*/
	jQuery.extend( jQuery.fn.dataTableExt.oSort, {
	    "status-range-pre": function ( a ) {
	        var statusArr = ['','DOCUMENT REQUESTED', 'NO EVIDENCE PROVIDED', 'APPROVED', 'VARIED', 'DECLINED', 'EXPIRED', 'CANCELLED','NA'];
	        var spanTxt = $(a).text();
	        return statusArr.indexOf(spanTxt); 
	    },
	     "status-range-asc": function ( a, b ) {
	        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
	    },
	     "status-range-desc": function ( a, b ) {
	        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
	    }
	} );

	
	var table = $('#studentHistoryTbl').DataTable({
		responsive: true,
        "iDisplayLength": 25,
        "aLengthMenu": [[5,10, 20, 25, 50, -1], [5,10, 20, 25, 50, "All"]],
        "pagingType": "simple_numbers",
        "dom": '<"top">rt<"bottom"ilp><"clear">',
        "columnDefs" : [{"targets": 8,"searchable":false,"orderable":false,"className": "dt-body-center"},
                        {"targets": 4,type:"status-range","className": "dt-body-center"},{"targets":7, "type":"date-dd-mmm-yyyy", width: '14%'}
                        ],
        "order": [[ 4, "asc" ]]
	 
    });
	
	
	// Handle click on "Select all" control
	   $('#example-select-all').on('click', function(){
	      // Check/uncheck all checkboxes in the table
	      var rows = table.rows({ 'search': 'applied' }).nodes();
	      $('input[type="checkbox"]', rows).prop('checked', this.checked);
	   });
	 // Handle "uncheck" the top checkbox
	   $('input[type="checkbox"]').on('click', function(){
	   	  var checkBoxId = $(this).attr("id");
	   	  if(checkBoxId!='example-select-all'){
	   		  $('#example-select-all').prop('checked', false);
	   	  }
	   });
	   
	// Event listener to the assignee filtering selection box to redraw on selected
	   $('#selAssign').on('change', function(){
	        table.draw();
	    } );
	   
	   $( function() {
		    var availableTags = [
		      "Farhan Rayani",
		      "Dewang Shahu",
		      "Heather Fielding",
		      "Kate Aylmore",
		      "Anton Terblanche",
		      "Hari Beesam",
		      "Boram Kwom",
		      "Jason Hay",
		      "John Smith",
		      "Beren Smith",
		      "Chris Dunstall",
		      "Alex Hale"
		    ];
		    $( "#tags" ).autocomplete({
		      source: availableTags
		    });
		    $( "#tags_bottom" ).autocomplete({
			      source: availableTags
			    });
		  } );
	   	
	   
} );

/* Custom filtering function which will search data in column four */
$.fn.dataTable.ext.search.push(
    function( settings, data, dataIndex ) {
        var assignSelValue = $( "#selAssign option:selected" ).val();
        if(assignSelValue==null || assignSelValue=="All"){
        	return true
        }
        else{
	        var assignee =data[6]
	        console.log("assignee "+assignee+"assignSelValue  "+assignSelValue)
	        if(assignee==assignSelValue){
	        	return true
	        }
	        else{
	        	return false
	        }
        }
       
    }
);
 