<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.utils.DateUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Track or Update Your Requests - Special Consideration Request Form</title>
    <asset:javascript src="trackRequest/request.js"/>
    <asset:javascript src="jquery.dataTables.min.js"/>
    <asset:javascript src="date-eu.js"/>
    <asset:stylesheet src="jquery.dataTables.min.css"/>
    <asset:stylesheet src="trackRequest.css"/>
    <asset:stylesheet src="unseen.css"/>
	
</head>
<body>
    <div class="content app-main" role="main">
      <div class="container-fluid">
         <div class="row pull-left">
            
                 <p>
                   	To view the details of an existing request or to upload supporting documents click the request below. 
				</p>
				<p>
					Contact <a href="http://student.csu.edu.au/services-support/student-central" target='_blank' class='external'>Student Central</a> if you need more help. 
				</p>
            
        </div>
      </div>
     <div class="clearfix"></div>
        <div>
        	<table id="trackingTbl" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		                <th style="text-align:center">Request Type</th>
		                <th style="text-align:center">Subject</th>
		                <th style="text-align:center">Date submitted</th>
		                <th style="text-align:center">Status</th>
		                <th style="text-align:center">Notes</th>
		                <th style="display:none;">GUID</th>
		                <th style="display:none;">CreatedOn</th>
		            </tr>
		        </thead>
		        
		        <tbody>
		        	<g:each var="request" in="${requestList}">
			            <tr>
			            	
			                <td style="text-align:left;word-wrap: break-word">${request.requestType}</td> 
			                <td>
			                	<!-- For Not Submitted status, route it to the Subject selection page -->
			                	<g:if test="${request.statusCode == Constants.STATUS_NOT_SUBMITTED}">
				                	<a href="${createLink(controller: 'application', action: 'review', params: [mode: 'edit', guid: request.guid, newRequest: false])}">${request.subject}</a>
				                </g:if>
				                <!-- For Action Required status, route it to Request Update page -->
				                <g:if test="${request.statusCode == Constants.STATUS_ACTION_REQUIRED}">
				                	<a href="${createLink(controller: 'application', action: 'updateReveiwRequest', params: [mode: 'edit', guid: request.guid, requestId: request.id, newRequest: false])}">${request.subject}</a>
				                </g:if>
				                <!-- For ALL other statuses, route it to the View page -->
				                <g:if test="${(request.statusCode != Constants.STATUS_NOT_SUBMITTED && request.statusCode != Constants.STATUS_ACTION_REQUIRED)}">
				                	<a href="${createLink(controller: 'application', action: 'updateReveiwRequest', params: [mode: 'view', guid: request.guid, requestId: request.id, newRequest: false])}">${request.subject}</a>
				                </g:if>
				            </td>
				            
			                <td align="center">
			                	${request.statusCode > Constants.STATUS_NOT_SUBMITTED && request.dateSubmitted != null? "${request.dateSubmitted}" : 'N/A'}
			                </td>
			                <td align="center">
			                	<span style="display:none;">${request.statusCodeSortChar}</span>
			                	<!-- For Not Submitted requests -->
				                <g:if test="${request.statusCode == Constants.STATUS_NOT_SUBMITTED}">
				                	<g:link controller="application" action="review" class="btn btn-default btn-xs not-submitted" params="[guid: "${request.guid}", mode: 'edit', newRequest: false]" target="_self">${request.status}</g:link>
								</g:if>
								<!-- For Submitted and Processing requests -->
								<g:if test="${request.statusCode == Constants.STATUS_SUBMITTED  || request.statusCode == Constants.STATUS_PROCESSING}">
									<g:link controller="application" action="updateReveiwRequest" class="btn btn-primary btn-xs" params="[guid: "${request.guid}", requestId: "${request.id}", mode: "view"]" target="_self">${request.status}</g:link>
								</g:if>
								<!-- For Action Required requests -->
								<g:if test="${request.statusCode == Constants.STATUS_ACTION_REQUIRED}">
									<g:link controller="application" action="updateReveiwRequest" class="btn btn-danger btn-xs action-req" params="[guid: "${request.guid}", requestId: "${request.id}", mode: "edit"]" target="_self">${request.status}</g:link>									    
								</g:if>
								<!-- For Expired and Cancelled requests -->
								<g:if test="${request.statusCode == Constants.STATUS_EXPIRED || request.statusCode == Constants.STATUS_CANCELLED}">
				                	<g:link controller="application" action="updateReveiwRequest" class="btn btn-default btn-xs not-submitted" params="[guid: "${request.guid}", requestId: "${request.id}", mode: "view"]" target="_self">${request.status}</g:link>
								</g:if>
								<!-- For Approved requests -->
								<g:if test="${request.statusCode == Constants.STATUS_APPROVED}">
									<g:link controller="application" action="updateReveiwRequest" class="btn btn-success btn-xs" params="[guid: "${request.guid}", requestId: "${request.id}", mode: "view"]" target="_self">${request.status}</g:link>	
								</g:if>
								<!-- For Declined and Varied requests -->
								<g:if test="${request.statusCode == Constants.STATUS_DECLINED}">
									<g:link controller="application" action="updateReveiwRequest" class="btn btn-warning btn-xs declined" params="[guid: "${request.guid}", requestId: "${request.id}", mode: "view"]" target="_self">${request.status}</g:link>	
								</g:if>
								<g:if test="${request.statusCode == Constants.STATUS_VARIED}">
									<g:link controller="application" action="updateReveiwRequest" class="btn btn-warning btn-xs varied" params="[guid: "${request.guid}", requestId: "${request.id}", mode: "view"]" target="_self">${request.status}</g:link>   
								</g:if>
							</td>
			                
			                <td style="text-align:left;word-wrap: break-word">
			                	<!-- Not submitted -->
			                	<g:if test="${request.statusCode == Constants.STATUS_NOT_SUBMITTED}">
			                		Created ${request.createdOn}<br>
			                		Expires ${request.expirationDate} <span class="glyphicon glyphicon-exclamation-sign" style="color: red;"></span>
			                	</g:if>
			                	<!-- Processing -->
			                	<g:if test="${request.statusCode == Constants.STATUS_PROCESSING}">
			                		Estimated Completion ${request.estimatedCompletionDate}
			                	</g:if>
			                	<!-- Action Required -->
			                	<g:if test="${request.statusCode == Constants.STATUS_ACTION_REQUIRED}">
			                		Expires ${request.actionRequiredExpirationDate} <span class="glyphicon glyphicon-exclamation-sign" style="color: red;"></span>
			                	</g:if>
			                	<!-- Expired -->
			                	<g:if test="${request.statusCode == Constants.STATUS_EXPIRED}">
			                		Expired ${request.statusDate}
			                	</g:if>
			                	<!-- Cancelled -->
			                	<g:if test="${request.statusCode == Constants.STATUS_CANCELLED}">
			                		Cancelled ${request.statusDate}
			                	</g:if>
			                	<!-- Approved, Declined and Varied -->
			                	<g:if test="${request.statusCode == Constants.STATUS_APPROVED || request.statusCode == Constants.STATUS_DECLINED || request.statusCode == Constants.STATUS_VARIED}">
			                		Completed ${request.statusDate}
			                	</g:if>
			                </td>
			                <td style="display:none;">${request.guid}</td>
			                <td style="display:none;">${request.createdOn}</td>
			            </tr>
			        </g:each>
		        </tbody>
		    </table>
        </div>
	</div>
              

</body>
</html>
