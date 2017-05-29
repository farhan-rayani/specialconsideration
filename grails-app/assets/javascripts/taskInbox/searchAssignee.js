$(document).ready(function() {
	var table = $('#searchTbl').DataTable({
		responsive: true,
        "iDisplayLength": 25,
        "aLengthMenu": [[5,10, 20, 25, 50, -1], [5,10, 20, 25, 50, "All"]],
        "pagingType": "simple_numbers",
        "dom": '<"search-box"f>lt<"bottom"ip><"clear">',
        "order": [[ 0, "asc" ]],
        "oLanguage":{"sSearch":"Search for:"}
	 
    });
} );

