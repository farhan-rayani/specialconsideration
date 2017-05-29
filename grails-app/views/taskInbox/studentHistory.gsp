<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Track or Update Your Requests - Special Consideration Request Form</title>
  
    <asset:javascript src="jquery.dataTables.min.js"/>
    <asset:javascript src="dataTables.buttons.min.js"/>
    <asset:javascript src="date-dd-MMM-yyyy.js"/>
    <asset:javascript src="taskInbox/jquery-ui.js"/>
    <asset:javascript src="taskInbox/bootbox.min.js"/>
    <asset:javascript src="taskInbox/searchPopup.js"/>
    <asset:javascript src="taskInbox/studentHistory.js"/>
    <asset:stylesheet src="jquery.dataTables.min.css"/>
    <asset:stylesheet src="buttons.dataTables.min.css"/>
    <asset:stylesheet src="taskInbox/studentHistory.css"/>
    <asset:stylesheet src="taskInbox/jquery-ui.css"/>
    <asset:stylesheet src="taskInbox/searchAssignee.css"/>
    <asset:stylesheet src="taskInbox/no-more-tables.css"/>
    
</head>

<body>
    <div class="content app-main" role="main">
           
         <div class="info-div">
         	<div class="info-heading">
     			<h3>Student Request History</h3>
     		</div>
     		
     		<div class="info-button">
     			<g:link action="awaitingRequest">
     			<button type="button" id="backSearch" class="btn btn-default btn-spacing pull-right btn-black" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                   Back To Awaiting Requests
               </button>
               </g:link>
     		</div>
     		
         </div>      
     	
     	<div class="filter-div">
     		<div class="student-number">
     			<label>For: 123456789</label>
     		</div>
     		<div class="student-name">
     			<label>Harrier Fieldwing</label>
     		</div>
     		<div class="span-assign"> 
     			<span>Assign Selected Requests to:</span>
     		</div>
     		
     		
     		<div class='input-search right-addon'>
		       <input id='tags' type='text'  class='form-control search-btn' placeholder='Me'/>
		       
		    </div>
  		    <div id="searchIcon" class="icon-search">
  		 		<span class='input-group-addon input-add'>
		          <i class='glyphicon glyphicon-search'></i>
		       </span>
  		    </div>
  		    
     		<div class="btn-assign">
     			<button class="btn btn-primary btn-spacing" type="button">Assign</button>
     		</div>
     	</div>
        <div class="search-tbl">
        	<table id="studentHistoryTbl" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		            	<th>Category</th>
		                <th>Request Type</th>
		                <th>Subject</th>
		                <th>Session</th>
		                <th>Status</th>
		                <th>Notes</th>
		                <th>Assigned To</th>
		                <th>Last Action Date</th>
		                <th id="row_checkbox"><input name="select_all" id="example-select-all" value="1" type="checkbox"></th>
		            </tr>
		        </thead>
		        
		        
		        <tbody>
		            
		             <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td id="notify">13-NOV-2016</td>
		                <td><input name="select_2" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-warning no-evidence">NO EVIDENCE PROVIDED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_2" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR224</td>
		                <td>201661</td>
		                <td><span class="label label-warning">VARIED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_2" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-danger action-req">DOCUMENT REQUESTED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_1" value="1" type="checkbox"></td>
		            </tr>
		            
		             <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-warning declined">DECLINED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>05-JAN-2017</td>
		                <td><input name="select_4" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		           
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-warning declined">DECLINED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>05-JAN-2017</td>
		                <td><input name="select_4" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		            
		             <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-warning declined">DECLINED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>05-JAN-2017</td>
		                <td><input name="select_4" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		            
		             <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-warning declined">DECLINED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>05-JAN-2017</td>
		                <td><input name="select_4" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		            
		             <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-warning declined">DECLINED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>05-JAN-2017</td>
		                <td><input name="select_4" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		           
		           <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td><span class="label label-success">APPROVED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person3 name</td>
		                <td>21-JAN-2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		           
		            
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td><span class="label label-info expired">EXPIRED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person1 name</td>
		                <td>21-JAN-2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td><span class="label label-default">CANCELLED</span></td>
		                <td>Expires 17-NOV-2016</td>
		                <td>Person2 name</td>
		                <td>13-NOV-2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		        </tbody>
		    </table>
        </div>
        
        <div id="bottom-filter-div" class="filter-div">
     		<div class="span-assign">
     			<span>Assign Selected Requests to:&nbsp;</span>
     		</div>
     		
     		
     		<div class='input-search right-addon'>
		       <input id='tags_bottom' type='text'  class='form-control search-btn' placeholder='Me'/>
		       
		    </div>
  		    <div id="searchIcon" class="icon-search">
  		 		<span class='input-group-addon input-add'>
		          <i class='glyphicon glyphicon-search'></i>
		       </span>
  		    </div>
  		    
     		<div class="btn-assign">
     			<button class="btn btn-primary btn-spacing" type="button">Assign</button>
     		</div>
     	</div>
	</div>
    
    <div id="search-container" style="display:none">
    	<g:render template="searchAssignee"/>
    </div>      
 </div>

</body>

	
</html>
