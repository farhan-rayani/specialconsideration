<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.enumstaff.Recommendation"%>
<%@ page import="au.edu.csu.specialcons.enumstaff.RejectionReason"%>
<%@ page import="au.edu.csu.specialcons.api.domain.Task" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Process Request</title>
    <asset:javascript src="jquery.dataTables.min.js"/>
    <asset:javascript src="taskInbox/bootbox.min.js"/>
    <asset:javascript src="taskInbox/searchPopup.js"/>
    <asset:javascript src="download.js"/>
    <asset:javascript src="taskInbox/jquery.typeahead.js"/>
    <asset:javascript src="taskInbox/dsoProcessRequest.js"/>
    <asset:stylesheet src="jquery.dataTables.min.css"/> 
    <asset:stylesheet src="taskInbox/dsoProcessRequest.css"/>
    <asset:stylesheet src="taskInbox/jquery.typeahead.css"/>
    <asset:stylesheet src="taskInbox/searchAssignee.css"/>
    <asset:stylesheet src="taskInbox/no-more-tables.css"/>
</head>
<body>
  
  <div class="content app-main" role="main">
   <form id="processReqForm" action="${AppUtils.getBaseUrl()}taskInbox/dsoProcessRequestAction" data-so-base-url="${AppUtils.getInteractUrl()}" method="POST" role="form" data-toggle="validator"> 
  	<input type="hidden" id="guid" name="guid" value="${guid}" />
  	<input type="hidden" id="taskId" name="taskId" value="${taskId}" />
  	<input type="hidden" id="assignedToName" name="assignedToName" value="${assignedToName}" />
  	
    <div class="container-fluid">
     <div class="row">
	      <div class="info-div">
	       	<div class="info-heading">
	   			<h3>Process Request</h3>
	   		</div>
	   		<div class="info-button">
     			<g:link action="awaitingRequest">
     			<button type="button" id="backSearch" class="btn btn-default btn-spacing pull-right btn-black" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                   Cancel Request
               </button>
               </g:link>
     		</div>
	   	 </div>
    	
     	
     	<div class="assign-div">
     		
     		<div class="sel-assign">
     			<div class="input-group-btn help-btn">
	                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
	                    title='Assigned to <a href="#" class="close" data-dismiss="alert">×</a>'
	                    data-toggle="popover"
	                    data-trigger="focus"
	                    data-content="<p>The request must be assigned to you to process.</p>">
	                </a>
           		</div>
     			<span><label>Assigned to:</label>&nbsp;&nbsp;&nbsp;&nbsp; <span id="assign-to">${assignedToName}</span></span>
     		</div>
     		
     		<div class="span-assign">
     			<span>Assign Request to:&nbsp;</span>
     		</div>
     		<div class='input-search right-addon typeahead__container'>
		       <span class="typeahead__query">
                	<input id='tags' name="tags" type='search' class='form-control search-btn' placeholder='Me' autocomplete="off"/>
            	</span>
		    </div>
  		    <div id="searchIcon" class="icon-search">
  		 		<span class='input-group-addon input-add'>
		          <i class='glyphicon glyphicon-search'></i>
		       </span>
  		    </div>
     		<div class="btn-assign">
     			<button id="assignBtn" name="assignBtn" type="submit"  class="btn btn-primary btn-spacing" value="assign">Assign</button>
     		</div>
     	</div>
     	
     	<div class="check-div">
     		<label>For Action: Check request details and documents</label>
     	</div>
     	
     	<div class ="supporting-div">
     		<div class="span-assign">
     			<asset:image class="tick-img" src="skin/tick.png" alt="tick" style="display:none"/>
     			<asset:image class="remove-img" src="skin/remove.png" alt="tick"/>
     			<span>Supporting documents checked&nbsp;</span>
     		</div>
     		<div class="btn-assign">
     			<button id="btn-assessment" class="btn btn-default btn-spacing btn-assessment" type="button" disabled="disabled">Send for Assessment</button>
     		</div>
     	</div>
     	<div class="div-tabs">
		  <ul class="nav nav-tabs">
		    <li class="active"><a data-toggle="tab" href="#home">Request Summary</a></li>
		    <li ><a data-toggle="tab" href="#menu1">Supporting Documents</a></li>
		  </ul>
		
		
		  <div class="tab-content">
		    <div id="home" class="tab-pane fade in active">
		    
		       <div class="block clearfix">
                        <div class="pull-left width-full" id="request">
                          		<div class="row">
	                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
	                            		<label>Date Submitted</label>
	                                </div>
	                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
                                        <span><g:dateFormat format="dd-MMM-yyyy" date="${subjectList[0]?.dateSubmitted}" /></span>
	                                 </div>
                            	</div>
                       			
                               <div class="row">
	                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
	                            		<label>Requesting</label>
	                                </div>
	                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7  text-left">
	                                 	<g:if test="${subjectList?.size() > 0}">
                                            <g:each var="subject" in="${subjectList}">
	                                 	<div>
                                 		   <span>${subject.subjectDisplay}:</span>
	                                 		<div>
	                                 			<span class="small-font">${subject.requestType}</span>
	                                 		</div>
                                 		</div>
                                 			</g:each>
                                 		</g:if>	
                                 		<g:else>
                                            <span>You have no subjects</span>
                                        </g:else>   
	                                </div>
							  </div>  
							  
							  
							  <div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Main reason for request</label>
                                </div>
                                 <div class="col-lg-5 col-md-7 col-sm-7 col-xs-7 text-left">
                                     <div>
                              		   <span>${subjectList[0].reason}</span>
                               			<div>
                               				<span class="small-font">${subjectList[0].reasonText}</span>
                               			</div>
                              	 	</div>
                                 </div>
                             </div>
                       		
                       		
                       		<div class="row" style="display:none">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Supporting documents </label>
                                </div>
                                 <div class="col-lg-5 col-md-7 col-sm-7 col-xs-7 text-left">
                                    <g:if test="${supportingDocuments?.size() > 0}">
                                        <g:each var="supportingDoc" in="${supportingDocuments}" status="i">
		                              	 	 <div id="doc1">
		                                   		<span>
		                                              <input type="hidden" id="file${i+1}data" value="data:${supportingDoc.mimeType};base64,${supportingDoc.content}" />
		                                              <input type="hidden" id="file${i+1}mime" value="${supportingDoc.mimeType}" />
		                                              <input type="hidden" id="file${i+1}name" value="${supportingDoc.fileName}" />
		                                              <button id="downloadFile" class="btn btn-link" documentId="${i+1}" class="btn btn-link" style="display:none;" type="button"> ${supportingDoc.fileName}</button>
		                                              <div id="viewFile${i+1}" class="view-file" style="display:none;">
		                                             
		                                              <g:if test="${supportingDoc.mimeType == 'application/msword'}">
		                                                 <button id="downloadFileLink" class="btn btn-link" documentId="${i+1}" type="button" type="button"> ${supportingDoc.fileName}</button>
		                                              </g:if>
		                                              <g:else>
		                                                  <g:link controller="application" action="showdocument" class="btn btn-link" params="[guid: "${guid}", docId: "${supportingDoc.docId}"]" target="_blank">${supportingDoc.fileName}</g:link>
		                                              </g:else>
		                                              </div>
		                                   		</span>
		                                   		
		                                   	</div>
                                   		</g:each>
                                   	</g:if>	
                                   	<g:else>
                                	  <div>
                           		   		<span>None provided</span>
                           	 		  </div>
                                   	</g:else>
                                 </div>
                             </div>
                       		
                       		<div class="clearfix">
                            	<div class="row">
			                    	<div class="col-md-12">
			                    		<hr style="width:100% !important; ">
			                    	</div>
			                    </div>
							</div>
							
							<div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Given name</label>
                                </div>
                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
                                       <span>${requestDetails.firstName}</span>
                                 </div>
                           	</div>
                       		
							
							<div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Family name</label>
                                </div>
                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
                                       <span>${requestDetails.lastName}</span>
                                 </div>
                           	</div>
                       		
                       		<div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Email Address</label>
                                </div>
                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
	                                  <span>${requestDetails.emailAddress}</span>
                                 </div>
                           	</div>
                       		
                       		
                       		<div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Student ID number</label>
                                </div>
                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
                                       <span>${requestDetails.studentId}</span>
                                 </div>
                           	</div>
                       		
                       		
                       		<div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Full course name</label>
                                </div>
                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
                                   <g:each var="course" in="${courseDetails}">
                                     <div>
                                         <span>${course?.programName}</span>
                                     </div>
                                   </g:each>
                                 </div>
                           	</div>
                       		  
                       		
                       		<div class="row">
                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                            		<label>Course code</label>
                                </div>
                                 <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left">
                                       <g:each var="course" in="${courseDetails}">
                                       	<span>${course?.programCode}</span>&nbsp;&nbsp;
                                       </g:each>
                                 </div>
                           	</div>             
					</div>
				</div>
		      
		      
		    </div> <!-- Home menu div -->
		    
		    <div id="menu1" class="tab-pane fade">
		      <g:if test="${flash.message}">
				    <div class="col-xs-12 alert alert-warning">
                        <div class="glyphicon glyphicon-exclamation-sign"></div>
                        <div>${flash.message}</div>
                    </div>
			  </g:if>	
		      <div class="block clearfix">
                 <div class="pull-left width-full" id="request">
                 	<div class="form-group">
                 		<span id="madatoryChkIcon" style="display:none"></span>
                 		<g:each var="supportingDoc" in="${supportingDocuments}" status="i">
		                   	<div class="row">
			                    <div class="col-lg-7 col-md-5 col-sm-5 col-xs-5 text-left">
			                    	<g:if test="${supportingDoc.mandatory == 1}">
			                    		<label>Mandatory Supporting Document</label>
			                    	</g:if>
			                    	<g:else>
			                    		<label>Additional Document ${i}</label>
			                    	</g:else>
			                    	
			                    	<span class="small-font red-txt">
			                    		<g:if test="${supportingDoc.mimeType == 'application/msword'}">
			                    			<div class="view-document">
			                    				<a href="#" class="downloadWordDoc" documentId="${i+1}">View document</a>
			                    			</div>
			                    		</g:if>
			                    		<g:else>
			                    			<div class="view-document">
			                    				<g:link class="showDoc" controller="application" action="showdocument"  params="[guid: "${guid}", docId: "${supportingDoc.docId}"]" target="_blank">View document</g:link>
			                    				<a href="#" class="downloadDoc" documentId="${i+1}">View document</a>
			                    			</div>
			                    			
			                    		</g:else>
			                    	</span>
			                    	
			                     </div>
		                        
		                      </div>
		                      
		                      <div class="row">
			                    <div class="col-lg-1 col-md-5 col-sm-5 col-xs-5 text-right">
			                    	<span class="small-font">Uploaded:</span>
			                     </div>
		                         <div class="col-lg-2 col-md-7 col-sm-7 col-xs-7 text-left">
		                            <span class="small-font"><g:dateFormat format="dd-MMM-yyyy" date="${supportingDoc.activityDate}" /></span>
		                         </div>
		                      </div>
		                      
		                      <div class="row">
			                   	 <div class="col-lg-7 col-md-5 col-sm-5 col-xs-5 checkbox-width text-left">
			                   	 	<label class="spcon-label" id="tooltip-document_chk${i+1}"> 
			                   			<g:checkBox id="document_chk${i+1}" name="madatoryChk" class="accept-chk"  value="${supportingDoc?.docId}" checked="${supportingDoc?.mandatoryOverride == 1}"/>
			                   			<span class="small-font span-space">Accept this document as the ‘mandatory document’</span>
			                   		</label>
			                     </div>
			                     
		                     </div> 
		                     
		                     
		                     <div class="clearfix">
	                          	<div class="row">
			                    	<div class="col-md-12">
			                    		<hr style="width:100% !important; ">
			                    	</div>
		                    	</div>
							</div>
							
						</g:each>
						<!-- removed html -->
				   
				   <div id="madatoryChkMessage"></div>
				   
				  </div><!-- form control end -->
				  
                   <div class="row">
	                    <div class="col-lg-6 col-md-5 col-sm-5 col-xs-5 text-left">
	                    	<span class="small-font">Recommendation</span>
	                     </div>
                         <div class="col-lg-5 col-md-7 col-sm-7 col-xs-7 text-left" id="reject-info-div" style="display:none">
                            <span class="small-font">Reason for rejecting the document</span>
                         </div>
                     </div>
                     
                     <div class="row" id="selection_row"><!-- start of row -->
                     	<div class="form-group">
		                    <div class="col-lg-6 col-md-5 col-sm-5 col-xs-5 text-left">
		                    	<div class="input-group">
		                    		<g:select class="form-control sel-assignment pull-left" name="selRecommendation"  id="selRecommendation" from="${Recommendation.values()}" optionKey="key"  noSelection="['':'Do you accept the documents?']" value="${supportingDocumentSel?.recommendation}"/>
			                    	<!--  <select class="form-control sel-assignment pull-left" id="selRecommendation" name="selRecommendation" required="true">
					     				<option value="">Do you accept the documents?</option><option value="Accept document">Accept Selected Document</option><option value="Reject Document">Reject Documents</option>
					     			</select>-->
					     			
					     			<div class="input-group-btn help-btn">
						                <a id="recommendation-help" tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
						                    title='Do you accept the document? <a href="#" class="close" data-dismiss="alert">×</a>'
						                    data-toggle="popover"
						                    data-trigger="focus"
						                    data-content="<p>Choose:<br><br>
												<b>Accept Selected Document</b>  if one of the provided documents is acceptable as the mandatory supporting document. 
												You must also select the relevant check box to indicate which document you are accepting.<br><br>
												<b>Reject Document</b>  if none of the provided documents are acceptable. The student will be 
												requested to send another document by email. You must also select the reason for rejection.</p>">
						                </a>
		            				</div>
		            			</div>
		                     </div>
		                  </div>
	                     <div class="form-group">
	                          <div class="col-lg-6 col-md-5 col-sm-5 col-xs-5 text-left" id="reject-sel-div" style="display:none">
	                          	<div class="input-group">
	                          		<g:select class="form-control sel-assignment pull-left" id="selRej" name="selRej" from="${RejectionReason.values()}" optionKey="key"  noSelection="['':'Select the reason']" value="${supportingDocumentSel?.reason}"/>
			                    	<!--  <select class="form-control sel-assignment pull-left" id="selRej" name="selRej" required="true">
					     				<option value="">Select the reason</option><option value="N">Not acceptable</option><option value="C">Cannot open or read document</option>
					     			</select>-->
					     			<div class="input-group-btn help-btn">
						                <a id="rej-reason-help" tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
						                    title='Reason for rejecting the document <a href="#" class="close" data-dismiss="alert">×</a>'
						                    data-toggle="popover"
						                    data-trigger="focus"
						                    data-content="<p>If you choose 'Not acceptable' the text in Email to the student will say: 'The information in the mandatory supporting document you provided is not acceptable.'<br><br>
														If you choose 'Cannot open or read document' the text in the Email to the student will say: 
														'We are unable to open and/or read your  mandatory supporting document'</p>">
						                </a>
		            				</div>
		            			 </div>	
		                     </div>
		                 </div>
                     </div> <!-- end of row -->
                     <br>
                     
                   <div class="clearfix">
                      <div class="row">
	                   	<div class="col-md-12">
	                   		<hr style="width:100% !important; ">
	                   	</div>
                      </div>
				   </div>
                   
                   <div class="btn-save">
	     			<button class="btn btn-primary btn-spacing" type="submit" id="save-btn" name="save" value="save">Save for Later</button>
	     		   </div>
                   
                   <br>
				   
                  </div><!-- End of request -->
               </div><!-- End of block -->
		    </div><!-- End of menu1 -->
		   
		  </div>
	  </div><!-- Tab div close -->
	  
	  <div class ="supporting-div">
     		<div class="span-assign">
     			<asset:image class="tick-img" src="skin/tick.png" alt="tick" style="display:none"/>
     			<asset:image class="remove-img" src="skin/remove.png" alt="tick"/>
     			<span>Supporting documents checked&nbsp;</span>
     		</div>
     		<div class="btn-assign">
     			<button class="btn btn-default btn-spacing btn-assessment" type="button" disabled="disabled">Send for Assessment</button>
     		</div>
     	</div>
	  
     </div>
     </div>
     
     <div class="modal fade" id="confirmAssessmentModal" tabindex="-1" role="dialog" aria-labelledby="confirmAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Are you sure you want to send for <br>assessment?</p>
                        <div class="row modal-button-row">
                            <div class="row">
                                <span id="loading" class="btn"></span>
                            </div>
                            <button type="button" id="saveAppNo" class="btn btn-default btn-spacing" data-dismiss="modal">
                                No
                            </button>
                            <button type="submit" id="sendAssessment" name="sendAssessment" class="btn btn-primary btn-spacing" value="sendAssessment">
                                Yes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
     
       <div class="modal fade" id="confirmRejModal" tabindex="-1" role="dialog" aria-labelledby="confirmAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Are you sure you want to send a request for <br>further documentation to the student?</p>
                        <div class="row modal-button-row">
                            <div class="row">
                                <span id="loading" class="btn"></span>
                            </div>
                            <button type="button" id="saveAppNo" class="btn btn-default btn-spacing" data-dismiss="modal">
                                No
                            </button>
                            <button type="submit" id="sendAssessment" name="sendAssessment" class="btn btn-primary btn-spacing" value="sendAssessment">
                                Yes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
     </form>
     <div id="search-container" style="display:none">
    	<g:render template="searchAssignee"/>
    </div>    
  </div>
 </body>
</html>
