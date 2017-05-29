var checked = 0
$(document).ready(function() {
	var table = $('#dsoAwaitingTbl').DataTable({
		responsive: true,
        "iDisplayLength": 25,
        "aLengthMenu": [[5,10, 20, 25, 50, -1], [5,10, 20, 25, 50, "All"]],
        "pagingType": "simple_numbers",
        "dom": '<"top">rt<"bottom"ilp><"clear">',
        "columnDefs" : [
                        {"targets":3, "type":"date-dd-MM-yyyy HH:mm"},
                        {"targets": 5,"searchable":false,"orderable":false,"className": "dt-body-center"},
                        {"targets": 1,"className": "dt-body-center"}
        			   ],
        "order": [[ 3, "asc" ]],
        "language":{"zeroRecords": "There are no tasks to show."}
	 
    });
	
	// Redirect to student history
	
	
	// Handle click on "Select all" control
	   $('#example-select-all').on('click', function(){
	      // Check/uncheck all checkboxes in the table
	      var rows = table.rows({ 'search': 'applied' }).nodes();
	      $('input[type="checkbox"]', rows).prop('checked', this.checked);
	   });
	 //Handle "uncheck" the top checkbox
	   $(document).on("click", ".checkbox" , function(){
	   	  var checkBoxId = $(this).attr("id");
	   	  //console.log(checkBoxId + " "+this.checked)
	   	  if(checkBoxId!='example-select-all'){
	   		  $('#example-select-all').prop('checked', false);
	   	  }
		  if(this.checked){
			  $('.btn').removeAttr('disabled');	
			  checked++;
		  }
		  else{
			  checked--;
			  if(checked == 0){
				  $('.btn').attr('disabled','disabled');
			  }
			  console.log(checked)
		  }
	   });  
	// Event listener to the assignee filtering selection box to redraw on selected
	   $('#selAssign').on('change', function(){
	        table.draw();
	    } );
	   
	   $('.tasks').on('click', function(){
		   $('#selAssign').val($(this).prop("id")).change();
	   } );
	   
	   $.typeahead({
		    input: '.search-btn',
		    order: "desc",
		    source: {
		        data: [
			'Asilika Kumar',
			'Catherine Cranston',
			'Elizabeth Purcell',
			'Elira Willan',
			'Fiona Reedy',
			'Helen Syme',
			'Janice Korner',
			'Julie Linsell',
			'Jane Press',
			'Jason Hay',
			'Laura Bloomfield',
			'Lorem Ipsum',
			'Maria Drinkwater',
			'Marilyn Goldsmith',
			'Natalie Raczkowski',
			'Patsy Suckling',
			'Suzanne Jones',
			'Sushma Sharma',
			'Vicki Hennock'
		        ]
		    }
		});
	   
	   $(document).on("click", ".popover .close" , function(){
	       $(this).parents(".popover").popover('hide');
	  });
} );

/* Custom filtering function which will search data in column four */
$.fn.dataTable.ext.search.push(
    function( settings, data, dataIndex ) {
        var assignSelValue = $( "#selAssign option:selected" ).text();
        assignSelValue = assignSelValue.replace("Assigned to ", "");
        if(assignSelValue==null || assignSelValue=="All Awaiting Tasks"){
        	return true
        }
        else{
	        var assignee
	        if(assignSelValue=="Overdue Tasks"){
	        	assignee = data[6]
	        }
	        else{
	        	
	        	assignee = data[4]
	        }
	        
	        
	        if(assignee==assignSelValue){
	        	return true
	        }
	        else{
	        	return false
	        }
        }
       
    }
);
 