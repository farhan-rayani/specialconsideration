<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Track Application Request</title>
  
    <asset:javascript src="jquery.dataTables.min.js"/>
    <asset:javascript src="dataTables.buttons.min.js"/>
    <asset:javascript src="date-eu.js"/>
    <asset:javascript src="taskInbox/searchAssignee.js"/>
    <asset:stylesheet src="jquery.dataTables.min.css"/>
    <asset:stylesheet src="buttons.dataTables.min.css"/>
    <asset:stylesheet src="taskInbox/searchAssignee.css"/>
    <asset:stylesheet src="taskInbox/bootstrap-responsive.min.css"/>
    <asset:stylesheet src="taskInbox/no-more-tables.css"/>
	
	
	
</head>
<body>
    <div class="content app-main" role="main">
      <div class="container-fluid">
         <div class="row">
            <div class="block">
                
         <div class="info-div">
         	<div class="info-heading">
     			<h3>Search For Assignee</h3>
     		</div>
         </div>      
     	
     	
        <div id="no-more-tables" class="search-tbl">
        	<table id="searchTbl" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		            	<th>Name</th>
		                <th>Email</th>
		                <th>Staff ID</th>
		                <th>CSU Login ID</th>
		            </tr>
		        </thead>
		        
		        
		        <tbody>
		            <tr>
		                <td data-title="Name">Farhan Rayani</td> 
		                <td data-title="Email">frayani@csu.edu.au</td>
		                <td data-title="StaffId">201660</td>
		                <td data-title="LoginId">frayani</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Kate Aylmore</td> 
		                <td data-title="Email">kaylmore@csu.edu.au</td>
		                <td data-title="StaffId">201661</td>
		                <td data-title="LoginId">kaylomore</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Chris Dunstall</td> 
		                <td data-title="Email">cdunstall@csu.edu.au</td>
		                <td data-title="StaffId">201662</td>
		                <td data-title="LoginId">cdunstall</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Kelli Edwards</td> 
		                <td data-title="Email">ekelli@csu.edu.au</td>
		                <td data-title="StaffId">201663</td>
		                <td data-title="LoginId">ekelli</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Heather Fielding</td>
		                <td data-title="Email">hfielding@csu.edu.au</td>
		                <td data-title="StaffId">201664</td>
		                <td data-title="LoginId">hfielding</td>
		            </tr>
		             <tr>
	  					<td data-title="Name">Jason Hay</td>
		                <td data-title="Email">jhay@csu.edu.au</td>
		                <td data-title="StaffId">201665</td>
		                <td data-title="LoginId">jhay</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Boram Kwon</td>
		                <td data-title="Email">bkwon@csu.edu.au</td>
		                <td data-title="StaffId">201666</td>
		                <td data-title="LoginId">bkwon</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		             
		              <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		            
		             <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		            
		             <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		            
		             <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		            
		             <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		            
		             <tr>
		                <td data-title="Name">Dewang Shahu</td>
		                <td data-title="Email">dshahu@csu.edu.au</td>
		                <td data-title="StaffId">201667</td>
		                <td data-title="LoginId">dshahu</td>
		            </tr>
		            <tr>
		                <td data-title="Name">John Smith</td>
		                <td data-title="Email">jsmith@csu.edu.au</td>
		                <td data-title="StaffId">201668</td>
		                <td data-title="LoginId">jsmith</td>
		            </tr>
		            <tr>
		                <td data-title="Name">Anton Terblanche</td>
		                <td data-title="Email">aterblanche@csu.edu.au</td>
		                <td data-title="StaffId">201669</td>
		                <td data-title="LoginId">aterblanche</td>
		            </tr>
		            
		        </tbody>
		    </table>
        </div>

</body>
</html>
