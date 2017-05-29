var box;
$(document).ready(function() {
	
	$('.icon-search').on('click', function(){
	      var container = $('#search-container').clone();
	      container.find('table').attr('id', 'searchTbl');
	
	        box = bootbox.dialog({
	        show: false,
	        title: "Search for Assignee",
	        message: container.html()
	      });
	      
	      box.on("shown.bs.modal", function() {
	    	  $('#searchTbl').DataTable({
	    			responsive: true,
	    	        "iDisplayLength": 10,
	    	        "aLengthMenu": [[5,10, 20, 25, 50, -1], [5,10, 20, 25, 50, "All"]],
	    	        "pagingType": "simple_numbers",
	    	        "dom": '<"search-box"f>t<"bottom"ilp><"clear">',
	    	        "order": [[ 0, "asc" ]],
	    	        "oLanguage":{"sSearch":"Search for:"}
	    		 
	    	    });
	    	  box.attr("id", "search-modal"); 
	    	 $("div.dataTables_filter input").focus();
	      });
	      
	      box.modal('show'); 
	});
	
	$(document).on("click", ".link-name", function(event){
		   $("#tags").val($(this).text());
		   $("#tags_bottom").val($(this).text());
		   box.modal('hide'); 
	});
});