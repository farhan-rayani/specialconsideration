<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
     <g:if test="${mode == 'view' || mode == '' || mode == null}">
        <title>Review Request - Special Consideration Request Form</title>
    </g:if>
    <g:if test="${mode == 'edit'}">
        <title>Review Request - Upload Document - Special Consideration Request Form</title>
    </g:if>
    <asset:stylesheet src="fileinput.css"/>
    <asset:javascript src="bootstrap-fileinput/plugins/canvas-to-blob.min.js"/>
    <asset:javascript src="bootstrap-fileinput/plugins/sortable.min.js"/>
    <asset:javascript src="bootstrap-fileinput/plugins/purify.min.js"/>
    <asset:javascript src="bootstrap-fileinput/fileinput.js"/>
    <asset:javascript src="bootstrap-fileinput/fileinput.min.js"/>
    <asset:javascript src="download.js"/>
    <asset:javascript src="application/updateReview.js"/>
</head>
<body>
    <div class="content app-main" role="main">

        <g:uploadForm name="scApplicationReviewForm" elementId="scApplicationReviewForm" controller="application" action="save" method="POST">
            <input type="hidden" name="saveStep" value="UPDATE_REVIEW" />
            <input type="hidden" id="guid" name="guid" value="${guid}" />
            <input type="hidden" id="requestid" name="requestid" value="${requestId}" />
            <input type="hidden" id="mode" name="mode" value="${mode}" />
            <input type="hidden" id="newRequest" name="newRequest" value="${newRequest}" />

            <div class="block clearfix">
            <div class="row">
                <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                    <label> Date submitted</label>
                </div>
                 <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                    <div>
                        <span>${requestDetails.requestDate}</span>                                
                    </div>
                 </div>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                    <label> Request status </label>
                </div>
                 <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                    <div>
                        <!-- For Not Submitted requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_NOT_SUBMITTED || requestDetails.statusCode == Constants.STATUS_EXPIRED || requestDetails.statusCode == Constants.STATUS_CANCELLED}">
                            <span class="label label-default not-submitted text-uppercase">${requestDetails.status}</span>
                        </g:if>
                        <!-- For Submitted and Processing requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_SUBMITTED || requestDetails.statusCode == Constants.STATUS_PROCESSING}">
                            <span class="label label-primary text-uppercase">${requestDetails.status}</span>
                        </g:if>
                        <!-- For Action Required requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_ACTION_REQUIRED}">
                            <span class="label label-danger action-req text-uppercase">${requestDetails.status}</span>
                        </g:if>
                        
                        <!-- For Approved requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_APPROVED}">
                            <span class="label label-success text-uppercase">${requestDetails.status}</span>  
                        </g:if>
                        <!-- For Declined requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_DECLINED}">
                            <span class="label label-warning declined text-uppercase">${requestDetails.status}</span>  
                        </g:if>
                        <!-- For Varied requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_VARIED}">
                            <span class="label label-warning varied text-uppercase">${requestDetails.status}</span>   
                        </g:if>                                
                    </div>
                 </div>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                    <label> Status detail</label>
                </div>
                 <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                    <div>
                         <!-- For Processing requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_PROCESSING}">
                            <span>This request is currently being processed</span>
                        </g:if>
                        <!-- For Action Required requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_ACTION_REQUIRED}">
                            <span>Please upload ${(mandatorySupportingDocsSubmitted == 0) ? '' : 'required '}<g:link url="http://student.csu.edu.au/services-support/student-central/askcsu#/article/13531" target='_blank' class='external'>mandatory supporting documentation</g:link></span>
                        </g:if>
                        <!-- For Approved requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_APPROVED}">
                            <span>This request was approved on ${requestDetails.statusDate}</span>  
                        </g:if>
                        <!-- For Declined requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_DECLINED}">
                            <span>This request was declined on ${requestDetails.statusDate}</span>  
                        </g:if>
                        <!-- For Varied requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_VARIED}">
                            <span>This request was varied on ${requestDetails.statusDate}</span>   
                        </g:if>                 
                        <!-- For Expired requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_EXPIRED}">
                            <span>This request expired on ${requestDetails.statusDate}. If required, you can start a <a href="${createLink(uri: '/', absolute: true)}">new request</a></span>   
                        </g:if>                 
                         <!-- For Cancelled requests -->
                        <g:if test="${requestDetails.statusCode == Constants.STATUS_CANCELLED}">
                            <span>This request was cancelled on ${requestDetails.statusDate}. If required, you can start a <a href="${createLink(uri: '/', absolute: true)}">new request</a></span></span>   
                        </g:if>                               
                    </div>
                 </div>
            </div>
            <g:if test="${mode == 'edit'}">
                <div class="block clearfix">
                        <div class="row pad-left-5em">
                            <div class="col-lg-1 col-md-5 col-sm-5 col-xs-5 text-left">
                            </div>
                             <div class="col-lg-11 col-md-7 col-sm-7 col-xs-7 text-left">
                             <g:if test="${mandatorySupportingDocsSubmitted == 0}">
                                <p><strong>Please upload mandatory supporting documentation.</strong> You can also upload up to two additional supporting documents.</p>
                            </g:if>
                            <g:else>
                                <p><strong>Please upload requested supporting documentation.</strong> We have sent you an email with details of the requested document.</p>
                            </g:else>
                             </div>
                        </div>

                        <div class="row pad-left-5em">
                            <div class="col-lg-1 col-md-5 col-sm-5 col-xs-5 text-left">
                            </div>
                             <div class="col-lg-11 col-md-7 col-sm-7 col-xs-7 text-left">
                                The current limitations on uploads are:
                                <ul>
                                    <li>The maximum document size is 5 MB per document</li>
                                    <li>Avoid using special characters in file names like : + ! &amp; # % ^ * ? @ = / \ | ` ; ~ ,</li>
                                    <li>The document file types must be PDF, DOC, DOCX, JPG, JPEG, RTF, BMP and PNG</li>
                                    <li>Unfortunately we cannot accept compressed (ZIP) files</li>
                                </ul>
                            </div>
                        </div>

                        <div class="row form-row supportDocument0 form-group" id="supportDocument0">
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1"></div>
                            <g:if test="${mandatorySupportingDocsSubmitted == 0}">
                                <label class="col-lg-3 col-md-5 col-sm-8 col-xs-8 spcon-label-horiz spcon-label text-right">Mandatory supporting document</label>
                            </g:if>
                            <g:else>
                                <label class="col-lg-3 col-md-5 col-sm-8 col-xs-8 spcon-label-horiz spcon-label text-right">Requested supporting document</label>
                            </g:else>
                            <div class="col-lg-5 col-md-5 col-sm-4 col-xs-4 pull-left">
                                <div id="file-tooltip">
                                    <g:field id="documentFile1" name="documentFile1" type="file" data-initial-caption="" data-initial-file="" required="true"/>
                                </div>
                                <p id="fileError0" data-error=""></p>
                                
                            </div>
                        </div>

                        
                            <div id="supportDocument1" class="row form-row supportDocument1 form-group ${(mode == 'edit' && documentList?.size() > 1) ? '' : ' hidden-row'}" >
                               <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1"></div>
                                <label class="col-lg-3 col-md-5 col-sm-8 col-xs-8 spcon-label-horiz spcon-label text-right">Additional supporting document</label>
                                <div class="col-lg-5 col-md-5 col-sm-4 col-xs-4 pull-left">
                                    <div>
                                        <g:field id="documentFile2" name="documentFile2" type="file" data-initial-caption="" data-initial-file=""/>
                                    </div>
                                    <p id="fileError1" class="help-block" data-error=""></p>
                                   
                                </div>
                            </div>

                            <div id="supportDocument2" class="row form-row supportDocument1 form-group ${(mode == 'edit' && documentList?.size() > 2) ? '' : ' hidden-row'}" >
                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1"></div>
                                <label class="col-lg-3 col-md-5 col-sm-8 col-xs-8 spcon-label-horiz spcon-label text-right">Additional supporting document</label>
                                <div class="col-lg-5 col-md-5 col-sm-4 col-xs-4 pull-left">
                                        <g:field id="documentFile3" name="documentFile3" type="file" data-initial-caption="" data-initial-file=""/>
                                    </div>
                                    <p id="fileError2" class="help-block" data-error=""></p>
                                   
                                </div>
                            </div>

                            <div class="row form-row ${(mandatorySupportingDocsSubmitted == 0) ? '' : ' hidden-row'}">
                                <div class="form-group text-center">
                                    <div class="form-row addDocumentButton" id="tooltip-addDoco">
                                        <button type="button" id="addDocument" class="btn btn-default" disabled>
                                            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span> Add another document
                                        </button>
                                    </div>
                                    <div class="form-row addDocumentButton hidden" id="removeDocoDiv">
                                        <button type="button" id="removeDocument" class="btn btn-default">
                                            <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> Remove additional document
                                        </button>
                                    </div>
                                </div>
                            </div>
                         
                          <hr class="hr-divider"/>

                        <div class="block clearfix">
                            <div class="row modal-button-row">
                                 <div class="col-md-12 form-row text-center">
                                     <button type="button" id="uploadDocuments" class="btn btn-app btn-spacing" disabled>
                                         Upload Document
                                     </button>
                                  </div>
                            </div>

                        </div>
               </div>
            </g:if>
                <div class="">
                        <hr class="hr-divider"/>
                        <div class="" id="request">
                          		<div class="row">
	                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
	                            		<label>Requesting</label><br>
	                                </div>
	                                 <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                                         <g:if test="${subjectList?.size() > 0}">
                                            <g:each var="subject" in="${subjectList}">
                                                <g:if test="${subject.requestId == requestId.toInteger()}">
                                                    <div>
                                                        <span>${subject.subjectDisplay}:</span>
                                                        <div>
                                                            <span>${subject.requestType}</span>
                                                        </div>
                                                        <br>
                                                    </div>
                                                </g:if>
                                            </g:each>
                                        </g:if>
                                        <g:else>
                                                <option value="">You have no subjects</option>
                                        </g:else>       	
	                                 </div>
                            	</div>
                                
                               <div class="row">
	                            	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
	                            		<label>Main reason for request</label><br>
	                                </div>
                                    <g:if test="${subjectList?.size() > 0}">
                                            <g:each var="subject" in="${subjectList}">
                                                <g:if test="${subject.requestId == requestId.toInteger()}">
                                                    <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                                        <g:if test="${subject.requestTypeCode != 'EXR' && subject.assessmentItem != 'COMPLETED'}">
                                                            <span>${subject.reason}</span>
                                                        </g:if>
                                                        <div>
                                                            <span style="width:75%; word-wrap:break-word; display:inline-block;">${subject.reasonText}</span>
                                                        </div>
                                                     </div>
                                                </g:if>
                                            </g:each>
                                        </g:if>
	                                 
								</div>                                
                                <br>
                                <div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Supporting documents</label><br>
                                    </div>
                                    <g:if test="${supportingDocuments?.size() == 0}">
                                        <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                            
                                            <g:if test="${requestDetails.statusCode < Constants.STATUS_EXPIRED}">
                                                <span>I will provide mandatory supporting documentation later</span>
                                            </g:if>
                                            <g:else>
                                                <span>Supporting documents uploaded with this request have been archived.</span>
                                            </g:else>
                                            
                                        </div>
                                    </g:if>
                                    <g:if test="${supportingDocuments?.size() > 0}">
                                        <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                            <g:each var="supportingDocument" in="${supportingDocuments}" status="counter">
                                                    <input  type="hidden" id="docID${counter+1}" value="${supportingDocument.docId}"/>
                                                    <input type="hidden" id="file${counter+1}data" value="data:${supportingDocument.mimeType};base64,${supportingDocument.content}" />
                                                    <input type="hidden" id="file${counter+1}mime" value="${supportingDocument.mimeType}" />
                                                    <input type="hidden" id="file${counter+1}name" value="${supportingDocument.fileName}" /> 
                                                    
                                                    <div id="downloadFile${counter+1}" class="downloadFile" style="display: none;">
                                                        <span>
                                                            <g:if test="${supportingDocument.mandatory == 1}">
                                                                  Mandatory:
                                                                </g:if>
                                                                <g:if test="${supportingDocument.mandatory == 0}">
                                                                   Additional:
                                                                </g:if>
                                                                <g:if test="${supportingDocument.mandatory == 2}">
                                                                   Requested:
                                                                </g:if>
                                                            <button class="btn btn-link csu-link"  type="button">${supportingDocument.fileName}</button>
                                                        </span>
                                                    </div>

                                                    <div class="viewFile" style="">
                                                        <span>
                                                            <g:if test="${supportingDocument.mandatory == 1}">
                                                              Mandatory:
                                                            </g:if>
                                                            <g:if test="${supportingDocument.mandatory == 0}">
                                                               Additional:
                                                            </g:if>
                                                            <g:if test="${supportingDocument.mandatory == 2}">
                                                               Requested:
                                                            </g:if>
                                                             <g:if test="${supportingDocuments[counter].mimeType == 'application/msword'}">
                                                                   <button id="downloadFileLink${counter+1}" class="btn btn-link csu-link" type="button" type="button">${supportingDocument.fileName}</button>
                                                            </g:if>
                                                            <g:else>
                                                                <g:link controller="application" action="showdocument external" class="btn btn-link csu-link" params="[guid: "${guid}", docId: "${supportingDocument.docId}"]" target="_blank">${supportingDocument.fileName}</g:link>
                                                            </g:else>
                                                        </span>
                                                    </div>
                                             	    
                                            </g:each>
                                        </div>
                                        
                                    </g:if> 
                            	</div>
                            	
                            	
                            	<div class="clearfix">
	                            	<div class="row">
				                    	<div class="col-md-12">
				                    		<hr>
				                    	</div>
				                    </div>
								</div>

                            	<div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Given name</label>
                                    </div>
                                     <div class="col-lg-9 col-md-6 col-sm-6 col-xs-6 pull-left">
                                     	<span>${requestDetails.firstName}</span>
                                     </div>
                                </div>
                                <br>
                                <div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Family name</label>
                                    </div>
                                     <div class="col-lg-9 col-md-6 col-sm-6 col-xs-6 pull-left">
                                     	<span>${requestDetails.lastName}</span>
                                     </div>
                                </div>
                                <br>
                                <div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Email address</label>
                                    </div>
                                     <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                     	<span>${requestDetails.emailAddress}</span>
                                        <input type="hidden" id="email" name="email" value="${requestDetails.emailAddress}" />
                                         <a tabindex="1" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                title='Update email address <a href="#" class="close" data-dismiss="alert">×</a>'
                                                data-toggle="popover"
                                                data-trigger="click"
                                                data-content="<p>To learn how to change your contact details or name, please visit <a href='http://student.csu.edu.au/services-support/student-central/faq?id=2692450' target='_blank' class='external'>AskCSU</a></p>"
                                                ></a>
                                        </div>
                                </div>
                                <br>
                                <div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Student ID number</label>
                                    </div>
                                     <div class="col-lg-9 col-md-6 col-sm-6 col-xs-6 pull-left">
                                     	<span>${requestDetails.studentId}</span>
                                     </div>
                                </div>
                                <br>
                                <div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Full course name</label>
                                    </div>
                                    <g:if test="${courseDetails?.size() > 0}">
                                        <g:each var="course" in="${courseDetails}">
                                            <div class="col-xs-5 pull-left">
                                                <span>${course.programName}</span>
                                            </div>
                                        </g:each>
                                    </g:if>
                                     
                                </div>
                                <br>
                                <div class="row">
                                	<div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                		<label>Course code</label>
                                    </div>
                                    <g:if test="${courseDetails?.size() > 0}">
                                        <g:each var="course" in="${courseDetails}">
                                            <div class="col-xs-5 pull-left">
                                                <span>${course.programCode}</span>
                                            </div>
                                        </g:each>
                                    </g:if>
                                </div>
                        	</div>
                            
                            <div class="col-md-12 form-row text-center">
                                <hr>
                            </div>
                             
                            

                             <div class="new-row">              
                                    <div class="row modal-button-row">
                                         <div class="col-md-12 form-row text-center">
                                             <button type="button" id="backToList" class="btn btn-default btn-spacing pull-left">
                                                 Back To List
                                             </button>
                                             <g:if test="${requestDetails.statusCode < Constants.STATUS_EXPIRED}">
                                                 <button type="button" id="cancel" class="btn btn-default btn-spacing pull-right" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                                                     Cancel Request
                                                 </button>
                                            </g:if>
                                          </div>
                                    </div>
                            </div>
                    	</div>              
                    <!--  End Reason Selection Block -->
                    
		            
    </g:uploadForm>


     <div class="modal fade" id="cancelAppModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Cancelling will withdraw your request</p>
                        <p>Are you sure you want to cancel?</p>
                        <div class="row modal-button-row">
                            <button type="button" id="cancelAppNo" class="btn btn-default btn-spacing" data-dismiss="modal">
                                No
                            </button>
                            <button type="button" id="cancelAppYes" class="btn btn-app btn-spacing">
                                Yes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

       <div class="modal fade" id="backToListModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>You haven’t uploaded selected document(s).</p>
                        <p>Are you sure you wish to leave this page?</p>
                        <div class="row modal-button-row">
                            <button type="button" id="abortBackToList" class="btn btn-default btn-spacing" data-dismiss="modal">
                                No
                            </button>
                            <button type="button" id="abortChanges" class="btn btn-app btn-spacing">
                                Yes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Document upload completed successfully.</p>
                        <div class="row modal-button-row">
                            <button type="button" id="ok" class="btn btn-app btn-spacing">
                                OK
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
  </div>
<!-- /.modal -->
 </body>
</html>
