<%@ page import="au.edu.csu.specialcons.api.domain.Task" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>	
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Track Application Request</title>
  
    <asset:javascript src="jquery.dataTables.min.js"/>
    <asset:javascript src="dataTables.buttons.min.js"/>
     <asset:javascript src="taskInbox/bootbox.min.js"/>
    <asset:javascript src="taskInbox/searchPopup.js"/>
    <asset:javascript src="date-dd-MMM-yyyy.js"/>
     <asset:javascript src="taskInbox/jquery.typeahead.js"/>
    <asset:javascript src="taskInbox/dsoAwaitingTask.js"/>
    <asset:stylesheet src="jquery.dataTables.min.css"/>
    <asset:stylesheet src="buttons.dataTables.min.css"/>
    <asset:stylesheet src="taskInbox/jquery.typeahead.css"/>
    <asset:stylesheet src="taskInbox/dsoAwaitingTask.css"/>
    <asset:stylesheet src="taskInbox/bootstrap-responsive.min.css"/>
    <asset:stylesheet src="taskInbox/unseen.css"/>
    <asset:stylesheet src="taskInbox/searchAssignee.css"/>
    <asset:stylesheet src="taskInbox/no-more-tables.css"/>
    
</head>

<body>
    <div class="content app-main" role="main">
      <form id="processReqForm" action="${AppUtils.getBaseUrl()}taskInbox/dsoAwaitingTaskAction" data-so-base-url="${AppUtils.getInteractUrl()}" method="POST" role="form">
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
	                	<span class="label label-info">ALL TASKS</span>
	                </div>
	            </div>
	            
	            <div class="summary">
	                <div class="number-col">
	                	<a href="#" class="tasks" id="${Task.ASSIGNED_TO+Task.ASSIGNED_ME}"><span class="number-value-blue">${myTasks}</span></a>
	                </div>
	                <div class="number-col">
	                	<a href="#" class="tasks" id="${Task.ASSIGNED_OVERDUE}"><span class="number-value-red">${overdue}</span></a>
	                </div>
	                <div class="number-col">
	                	<a href="#" class="tasks" id="${Task.ASSIGNED_NOT}"><span class="number-value-yellow">${notAssigned}</span></a>
	                </div>
	                <div class="number-col">
	                	<a href="#" class="tasks" id="${Task.ASSIGNED_ALL}"><span class="number-value-light-blue">${taskList.size()}</span></a>
	                </div>
	            </div>
            </div>
        </div>
      </div>
     <div class="clearfix"></div>
     	
     	<div class="filter-div">
     		<div class="sel-assign">
     			<!-- <select class="form-control sel-assignment pull-left" id="selAssign">
     				<option value="All">All Awaiting Tasks</option><option value="me">Assigned to me</option><option value="Person1 name">Assigned to Person1 name</option><option value="Person2 name">Assigned to Person2 name</option><option value="unassigned">Not Assigned</option><option value="overdue">Overdue requests</option>
     			</select>-->
     			<g:select class="form-control sel-assignment pull-left" id="selAssign" name="selAssign" optionKey="key" optionValue="value" from="${assignMap}" noSelection="['All':'All Awaiting Tasks']"/>
     			 <div class="input-group-btn help-btn">
	                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
	                    title='Filter Task List <a href="#" class="close" data-dismiss="alert">×</a>'
	                    data-toggle="popover"
	                    data-trigger="focus"
	                    data-content="<p>Select a filter to restrict the tasks shown.</p>">
	                </a>
            	</div>
     		</div>
     		
     		<div class="span-assign">
     			<span>Assign Selected Requests to:&nbsp;</span>
     		</div>
     		<div class='input-search right-addon typeahead__container'>
		       <span class="typeahead__query">
                	<input id='tags' name='tags' type='search' class='form-control search-btn' placeholder='Me' autocomplete="off"/>
            	</span>
		    </div>
  		    <div id="searchIcon" class="icon-search">
  		 		<span class='input-group-addon input-add'>
		          <i class='glyphicon glyphicon-search'></i>
		       </span>
  		    </div>
     		<div class="btn-assign">
     			<button class="btn btn-primary btn-spacing" type="submit" disabled="disabled">Assign</button>
     		</div>
     	</div>
     	
        <div id="unseen" class="search-tbl">
        	<table id="dsoAwaitingTbl" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		            	<th>Submission ID</th>
		                <th>Student Id</th>
		                <th>Student Name</th>
		                <th>Last Action Date</th>
		                <th>Assigned To</th>
		                <th id="row_checkbox"><input name="select_all" id="example-select-all" value="1" type="checkbox" class="checkbox"></th>
		                <th style="display:none">Assignees</th>
		            </tr>
		        </thead>
		        
		        
		        <tbody>
		           <!-- <tr>
		                <td>B174991F-8D54-4618-AD02-BB9FA5E9A4C6 </td> 
		                <td>123456789</td>
		                <td>Harrier Fieldwing</td>
		                <td>21-JAN-2017</td>
		                <td>Person1 name</td>
		                <td><input name="select_1" value="1" type="checkbox"></td>
		            </tr>
		            <tr>
		                <td><g:link controller="taskInbox" action="studentHistory">B174991F-8D54-4618-AD02-BB9FA5E9A4C7</g:link></td>
		                <td>999</td>
		                <td>Ant Blackmange</td>
		                <td id="notify">13-NOV-2016</td>
		                <td>Person2 name</td>
		                <td><input name="select_2" value="1" type="checkbox"></td>
		            </tr>-->
		           <g:each var="task" in="${taskList}" status="i">
		           	<tr>
		                <td><g:link controller="taskInbox" action="dsoProcessRequest" params="${[guid: task.guid,taskId:task.taskId,assignedToName:task.assignedToName]}">${task.guid}</g:link> </td> 
		                <td>${task.studentId}</td>
		                <td>${task.studentName}</td>
		                <g:if test="${task.isNotify}">
		                	<td id="notify" data-order='${task.lastActionDateStr}'>${task.lastActionDateStr}</td>
		                </g:if>
		                <g:else>
		                	 <td data-order='${task.lastActionDateStr}'>${task.lastActionDateStr}</td>
		               	</g:else>
		                <td>${task.assignedToName}</td>
		                <td><input name="assignChk" id="assignChk" value="${task.taskId}" class="checkbox" type="checkbox"></td>
		                <td style="display:none"><g:if test="${!task.isNotify}">Overdue Tasks</g:if></td>
		            </tr>
		          </g:each>
		           
		        </tbody>
		    </table>
        </div>
        
        <div id="bottom-filter-div" class="filter-div">
     		<div class="span-assign">
     			<span>Assign Selected Requests to:&nbsp;</span>
     		</div>
     		<div class='input-search right-addon typeahead__container'>
     			<span class="typeahead__query">
		       		<input id='tags_bottom' name='tags_bottom' type='search'  class='form-control search-btn' placeholder='Me' autocomplete="off"/>
		       	</span>
		    </div>
  		    <div id="searchIcon" class="icon-search">
  		 		<span class='input-group-addon input-add'>
		          <i class='glyphicon glyphicon-search'></i>
		       </span>
  		    </div>
     		<div class="btn-assign">
     			<button class="btn btn-primary btn-spacing" type="submit" disabled="disabled">Assign</button>
     		</div>
     	</div>
       </form>
       <div id="search-container" style="display:none">
    	 <g:render template="searchAssignee"/>
       </div>   
	</div>
              

</body>
</html>
