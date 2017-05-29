$(document).ready(function() {
	var table = $('#searchTbl').DataTable({
		responsive: true,
        "iDisplayLength": 25,
        "aLengthMenu": [[5,10, 20, 25, 50, -1], [5,10, 20, 25, 50, "All"]],
        "pagingType": "simple_numbers",
       // "dom": '<"toolbar"><"assignLabelTop"><"assignButtonTop"><"top"f>rt<"bottom"ilpf><"assignLabelBottom"><"assignButtonBottom"><"clear">',
        "dom": '<"top">rt<"bottom"ilp><"clear">',
        "columnDefs" : [{"targets":7, "type":"date-eu"},
                        {"targets": 8,"searchable":false,"orderable":false,"className": "dt-body-center"}],
        "order": [[ 7, "asc" ]]
	 
    });
	
	// Redirect to student history
	
	
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
	        if(assignee==assignSelValue){
	        	return true
	        }
	        else{
	        	return false
	        }
        }
       
    }
);
 