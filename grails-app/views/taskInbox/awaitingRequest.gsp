<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Track Application Request</title>
  
    <asset:javascript src="jquery.dataTables.min.js"/>
    <asset:javascript src="dataTables.buttons.min.js"/>
    <asset:javascript src="date-eu.js"/>
    <asset:javascript src="taskInbox/jquery-ui.js"/>
    <asset:javascript src="taskInbox/awaitingRequest.js"/>
    <asset:stylesheet src="jquery.dataTables.min.css"/>
    <asset:stylesheet src="buttons.dataTables.min.css"/>
    <asset:stylesheet src="taskInbox/awaitingRequest.css"/>
    <asset:stylesheet src="taskInbox/jquery-ui.css"/>
    <asset:stylesheet src="taskInbox/bootstrap-responsive.min.css"/>
    <asset:stylesheet src="taskInbox/unseen.css"/>
    
</head>

<body>
    <div class="content app-main" role="main">
      <div class="container-fluid">
         <div class="row">
        	 <div class="info-div">
	         	<div class="info-heading">
	     			<h3>Awaiting Tasks</h3>
	     		</div>
	     	  </div>
            <div class="block">
                <div class="summary">
	                <div class="summary-col">
	                	<span class="label label-primary">MY TASKS</span>
	                </div>
	                <div class="summary-col">
	                	<span class="label label-danger">OVERDUE</span>
	                </div>
	                <div class="summary-col">
	                	<span class="label label-warning">NOT ASSIGNED</span>
	                </div>
	                <div class="summary-col">
	                	<span class="label label-info">ALL REQUESTS</span>
	                </div>
	            </div>
	            
	            <div class="summary">
	                <div class="number-col">
	                	<span class="number-value-blue">8</span>
	                </div>
	                <div class="number-col">
	                	<span class="number-value-red">1</span>
	                </div>
	                <div class="number-col">
	                	<span class="number-value-yellow">1</span>
	                </div>
	                <div class="number-col">
	                	<span class="number-value-light-blue">15</span>
	                </div>
	            </div>
            </div>
        </div>
      </div>
     <div class="clearfix"></div>
     	
     	<div class="filter-div">
     		<div class="sel-assign">
     			<select class="form-control sel-assignment pull-left" id="selAssign">
     				<option value="All">All Awaiting Request</option><option value="me">Assigned to me</option><option value="Person1 name">Assigned to Person1 name</option><option value="Person2 name">Assigned to Person2 name</option><option value="unassigned">Not Assigned</option><option value="overdue">Overdue requests</option>
     			</select>
     		</div>
     		<div class="span-assign">
     			<span>Assign Selected Requests to: &nbsp;</span>
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
        <div id="unseen" class="search-tbl">
        	<table id="searchTbl" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		            	<th>Category</th>
		                <th>Request Type</th>
		                <th>Student Id</th>
		                <th>Student Name</th>
		                <th>Subject</th>
		                <th>Session</th>
		                <th>Assigned To</th>
		                <th>Last Action Date</th>
		                <th id="row_checkbox"><input name="select_all" id="example-select-all" value="1" type="checkbox"></th>
		            </tr>
		        </thead>
		        
		        
		        <tbody>
		            <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_1" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td><g:link controller="taskInbox" action="studentHistory">999</g:link></td>
		                <td><g:link controller="taskInbox" action="studentHistory">Ant Blackmange</g:link></td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td id="notify">13/11/2016</td>
		                <td><input name="select_2" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_3" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_4" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                 <td><input name="select_5" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                 <td><input name="select_6" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_7" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_8" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_9" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_10" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_11" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_12" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_13" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_14" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_15" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_15" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_16" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_17" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_18" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_19" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_20" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_21" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_22" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_23" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_24" value="1" type="checkbox"></td>
		            </tr>
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_13" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_14" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_15" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_15" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_16" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_17" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_18" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_19" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_20" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_21" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_22" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_23" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_24" value="1" type="checkbox"></td>
		            </tr>
		            
		            
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_13" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_14" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_15" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_15" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_16" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_17" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_18" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_19" value="1" type="checkbox"></td>
		            </tr>
		             <tr>
		                <td>Spc</td> 
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_20" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>SX</td>
		                <td>99999999</td>
		                <td>Ant Blackmange</td>
		                <td>EHR223</td>
		                <td>201660</td>
		                <td>Person2 name</td>
		                <td>13/11/2016</td>
		                <td><input name="select_21" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>In Session</td>
		                <td>Extension</td>
		                <td>98764321</td>
		                <td>Cake Eatmore</td>
		                <td>NUT220</td>
		                <td>201660</td>
		                <td>Person3 name</td>
		                <td>21/01/2017</td>
		                <td><input name="select_22" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>05/01/2017</td>
		                <td><input name="select_23" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td>Spc</td>
		                <td>GP</td>
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>JST495</td>
		                <td>201660</td>
		                <td>Person1 name</td>
		                <td>06/12/2016</td>
		                <td><input name="select_24" value="1" type="checkbox"></td>
		            </tr>
		            
		        </tbody>
		    </table>
        </div>
        
        <div id="bottom-filter-div" class="filter-div">
     		<div class="span-assign">
     			<span>Assign Selected Requests to: &nbsp;</span>
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
              

</body>
</html>
