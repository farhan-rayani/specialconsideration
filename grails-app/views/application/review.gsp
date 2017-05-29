<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<%@ page import="au.edu.csu.specialcons.enumstudent.ExemptionReason"%>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
     <g:if test="${newRequest == 'true' || mode == 'create' || mode == '' || mode == null}">
        <title>Request for Special Consideration - Special Consideration Request Form</title>
    </g:if>
    <g:if test="${newRequest == 'false' && mode == 'edit'}">
        <title>Update Request - Special Consideration Request Form</title>
    </g:if>
     
    <asset:javascript src="download.js"/>
    <asset:javascript src="application/review.js"/>
</head>
<body>
    <div class="content app-main" role="main">
      
        <form id="scApplicationReviewForm" action="${AppUtils.getBaseUrl()}application/save" data-so-base-url="${AppUtils.getInteractUrl()}" method="POST" role="form" data-toggle="validator">
            <input type="hidden" name="saveStep" value="REVIEW" />
            <input type="hidden" id="guid" name="guid" value="${guid}" />
            <input type="hidden" id="mode" name="mode" value="${mode}" />
            <input type="hidden" id="newRequest" name="newRequest" value="${newRequest}" />
            <g:set var="docProvidedSupSchool" value="${0}"/>
            <g:set var="docProvided" value="${0}"/>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-left">
                            <g:if test="${params.skipStep2 == 'true'}">
                                <h3>Step 2. Review your request</h3>
                            </g:if>
                            <g:else>
                                <h3>Step 3. Review your request</h3>
                            </g:else>
                        </div>

                        <!-- Wizard steps -->

                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="display:none">
                            <div class="pull-right">
                                <ul class="bootstrapWizard form-wizard">
                                    <li data-target="#step1" class="">
                                        <span class="step">1</span>
                                    </li>
                                    <li data-target="#step2" class="">
                                        <span class="step">2</span>
                                    </li>
                                    <li data-target="#step3" class="active">
                                        <span class="step active">3</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>

                <div class="clearfix"></div>

                <div id="actionResponse" role="alert"></div>
                <div class="block clearfix">
                    <div class="" id="request">
                        <g:if test="${Integer.valueOf(otherSCRequestsFlag) == 1}">
                                <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="requesting">Requesting</label><br>
                                        <a href="${createLink(action: 'editSubjects', params: [guid: guid, newRequest: newRequest])}">Modify</a>
                                    </div>
                                     <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                                         <g:if test="${subjectList?.size() > 0}">
                                            <g:each var="subject" in="${subjectList}">
                                                <g:if test="${subject.assessmentItem != 'COMPLETED' && subject.assessmentItem != 'PASSED'}">
                                                    <div>
                                                        <span>${subject.subjectDisplay}:</span>
                                                        <div>
                                                            <span>${subject.requestType}</span>
                                                            <g:if test="${subject.assessmentItem}">
                                                                <g:if test="${subject.assessmentItem != 'CANT_COMPLETE'}">
									               				    <br/><span>"${subject.assessmentItem}"</span>
                                                                </g:if>
                                                                <g:else>
                                                                    <br/><span>"${ExemptionReason.CANT_COMPLETE}"</span>
                                                                </g:else>
									               			</g:if>
									               			<g:if test="${subject.extensionDate}">
									               				<span>by ${subject.extensionDate}</span>
									               			</g:if>
                                                        </div>
                                                        <br>
                                                    </div>
                                                </g:if>
                                            </g:each>
                                        </g:if>
                                     </div>
                                </div>
                           
                               <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="requestReason">Main reason for request</label><br>
                                        <a href="${createLink(action: 'editReason', params: [guid: guid, newRequest: newRequest, fragment: 'reason'])}">Modify</a>
                                    </div>
                                     <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                     <g:set var="reasonDisplay" value="${0}"/>
                                        <g:if test="${subjectList?.size() > 0}">
                                            <g:each var="subject" in="${subjectList}">
                                                <g:if test="${subject.assessmentItem != 'COMPLETED' && subject.assessmentItem != 'PASSED' && reasonDisplay == 0}">
                                                    <g:set var="reasonDisplay" value="${1}"/>
                                                    <span>${subject.reason}</span>
                                                    <div>
                                                        <span style="width:75%; word-wrap:break-word; display:inline-block;">${subject.reasonText}</span>
                                                    </div>
                                                 </g:if>
                                            </g:each>
                                        </g:if>
                                     </div>
                                </div>                                
                                <br>
                                <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="supportingDoc">Supporting documents</label><br>
                                        <a href="${createLink(action: 'editReason', params: [guid: guid, newRequest: newRequest, fragment: 'suppDocs'])}">Modify</a>
                                        <br>
                                    </div>

                                    <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                        <g:if test="${supportingDocuments?.size() > 0 && supportingDocuments[0].requestid==0}">
                                            <g:set var="docProvided" value="${1}"/>
                                            <div id="doc1" class="">
                                                    <g:if test="${supportingDocuments[0].mimeType == 'application/msword'}">
                                                        <input type="hidden" id="file1data" value="data:${supportingDocuments[0].mimeType};base64,${supportingDocuments[0].content}" />
                                                    </g:if>
                                                    <input type="hidden" id="file1mime" value="${supportingDocuments[0].mimeType}" />
                                                    <input type="hidden" id="file1name" value="${supportingDocuments[0].fileName}" /> 
                                                    <div id="downloadFile1" style="display:none;">
                                                        
                                                        <button class="btn btn-link csu-link" type="button" onclick="downloadFile1()"> ${supportingDocuments[0].fileName}</button>
                                                    </div>
                                                    <div id="viewFile1" >
                                                        
                                                        <g:if test="${supportingDocuments[0].mimeType == 'application/msword'}">
                                                           <button id="downloadFileLink1" class="btn btn-link csu-link" type="button" type="button">${supportingDocuments[0].fileName}</button>
                                                        </g:if>
                                                        <g:else>
                                                            <g:link controller="application" action="showdocument" class="btn btn-link csu-link" params="[guid: "${guid}", docId: "${supportingDocuments[0].docId}"]" target="_blank" class="external">${supportingDocuments[0].fileName}</g:link>
                                                        </g:else>
                                                    </div>
                                            </div>
                                        </g:if> 
                                        <g:if test="${supportingDocuments?.size() > 1 && supportingDocuments[1].requestid==0}">
                                            <g:set var="docProvided" value="${1}"/>
                                            <div id="doc2" class="">
                                                     <g:if test="${supportingDocuments[1].mimeType == 'application/msword'}">
                                                        <input type="hidden" id="file2data" value="data:${supportingDocuments[1].mimeType};base64,${supportingDocuments[1].content}" />
                                                    </g:if>
                                                    <input type="hidden" id="file2mime" value="${supportingDocuments[1].mimeType}" />
                                                    <input type="hidden" id="file2name" value="${supportingDocuments[1].fileName}" />
                                                    <div id="downloadFile2" style="display:none;">
                                                        
                                                        <button class="btn btn-link csu-link" type="button" type="button" onclick="downloadFile2()"> ${supportingDocuments[1].fileName}</button>
                                                    </div>
                                                    <div id="viewFile2" >
                                                        
                                                        <g:if test="${supportingDocuments[1].mimeType == 'application/msword'}">
                                                            <button id="downloadFileLink2" class="btn btn-link csu-link" type="button" type="button"> ${supportingDocuments[1].fileName}</button>
                                                        </g:if>
                                                        <g:else>
                                                            <g:link controller="application" action="showdocument" class="btn btn-link csu-link" params="[guid: "${guid}", docId: "${supportingDocuments[1].docId}"]" target="_blank" class="external">${supportingDocuments[1].fileName}</g:link>
                                                        </g:else>
                                                    </div>
                                            </div>
                                        </g:if>
                                        <g:if test="${supportingDocuments?.size() > 2 && supportingDocuments[2].requestid==0}">
                                            <g:set var="docProvided" value="${1}"/>
                                            <div id="doc3" class="">
                                                     <g:if test="${supportingDocuments[2].mimeType == 'application/msword'}">
                                                        <input type="hidden" id="file3data" value="data:${supportingDocuments[2].mimeType};base64,${supportingDocuments[2].content}" />
                                                     </g:if>
                                                    <input type="hidden" id="file3mime" value="${supportingDocuments[2].mimeType}" />
                                                    <input type="hidden" id="file3name" value="${supportingDocuments[2].fileName}" />
                                                    <div id="downloadFile3" style="display:none;">
                                                        
                                                        <button class="btn btn-link csu-link" type="button" onclick="downloadFile3()"> ${supportingDocuments[2].fileName}</button>
                                                    </div>
                                                    <div id="viewFile3">
                                                        
                                                        <g:if test="${supportingDocuments[2].mimeType == 'application/msword'}">
                                                            <button id="downloadFileLink3" class="btn btn-link csu-link" type="button" type="button"> ${supportingDocuments[2].fileName}</button>
                                                        </g:if>
                                                        <g:else>
                                                            <g:link controller="application" action="showdocument" class="btn btn-link csu-link" params="[guid: "${guid}", docId: "${supportingDocuments[2].docId}"]" target="_blank" class="external">${supportingDocuments[2].fileName}</g:link>
                                                        </g:else>
                                                    </div>                
                                             </div>
                                        </g:if>
                                        <g:if test="${docProvided==0}">
                                             <div id="doc1" class="">
                                                <span>None provided</span>
                                            </div>
                                        </g:if>
                                    </div>
                                </div>
                                <div class="clearfix">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <hr>
                                        </div>
                                    </div>
                                 </div>
                            </g:if>
                             <!-- For Resi school exemption with previously PASSED subject-->
                              <g:if test="${Integer.valueOf(resiSchoolExemptionPassedFlag) == 1}">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                            <label for="requesting">Requesting</label><br>
                                            <a href="${createLink(action: 'editSubjects', params: [guid: guid, newRequest: newRequest])}">Modify</a>
                                        </div>
                                         <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                                             <g:if test="${subjectList?.size() > 0}">
                                                <g:each var="subject" in="${subjectList}">
                                                    <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'PASSED'}">
                                                        <div>
                                                            <span>${subject.subjectDisplay}:</span>

                                                            <div>
                                                                <span>${subject.requestType}</span>
                                                            </div>
                                                        </div>
                                                            <div>"${ExemptionReason.PASSED}"<br><br></div>              
                                                    </g:if>
                                                </g:each>
                                            </g:if>
                                         </div>
                                    </div>
                                    <div class="clearfix">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <hr>
                                            </div>
                                        </div>
                                     </div>
                            </g:if>        
                            <!-- End for mixed bag of requests i.e. those with exemption from resi school and various other types-->    
                            <g:if test="${Integer.valueOf(resiSchoolExemptionCompletedFlag) == 1 }">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                            <label for="requesting">Requesting</label><br>
                                            <a href="${createLink(action: 'editSubjects', params: [guid: guid, newRequest: newRequest])}">Modify</a>
                                        </div>
                                         <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                                             <g:if test="${subjectList?.size() > 0}">
                                                <g:each var="subject" in="${subjectList}">
                                                    <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'COMPLETED'}">
                                                        <div>
                                                            <span>${subject.subjectDisplay}:</span>
                                                            <div>
                                                                <span>${subject.requestType}</span>
                                                            </div>
                                                        </div>
                                                            <span>"${ExemptionReason.COMPLETED}"<br></span>
                                                    </g:if>
                                                </g:each>
                                            </g:if>
                                         </div>
                                    </div>
                                        <br>
                                        <div class="row">
                                            <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                                <label for="exemptionDetails">Details of exemption</label><br>
                                                <a href="${createLink(action: 'reasonResSchoolExemption', params: [guid: guid, newRequest: newRequest,skipStep2a:params.skipStep2a])}">Modify</a>
                                            </div>
                                             <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                                    <g:if test="${subjectList?.size() > 0}">
                                                        <g:each var="subject" in="${subjectList}">
                                                            <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'COMPLETED'}">
                                                                <div>
                                                                    <span style="width:75%; word-wrap:break-word; display:inline-block;">${subject.reasonText}</span>
                                                                </div>
                                                             </g:if>
                                                        </g:each>
                                                    </g:if>
                                             </div>
                                        </div>                                
                                        <br>
                                        <div class="row">
                                            <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                                <label>Supporting documents</label><br>
                                                <a href="${createLink(action: 'reasonResSchoolExemption', params: [guid: guid, newRequest: newRequest, fragment: 'suppDocs',skipStep2a:params.skipStep2a])}">Modify</a>
                                                <br>
                                            </div>
                                            <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                                <g:if test="${supportingDocuments?.size() > 0}">
                                                    <g:each var="supportingDocument" in="${supportingDocuments}">
                                                        <g:if test="${supportingDocument.requestid>0}">
                                                            <g:set var="docProvidedSupSchool" value="${1}"/>
                                                            <div id="doc1" class="">
                                                                    <g:if test="${supportingDocument.mimeType == 'application/msword'}">
                                                                        <input type="hidden" id="file1data" value="data:${supportingDocument.mimeType};base64,${supportingDocument.content}" />
                                                                    </g:if>
                                                                    <input type="hidden" id="file1mime" value="${supportingDocument.mimeType}" />
                                                                    <input type="hidden" id="file1name" value="${supportingDocument.fileName}" /> 
                                                                    <div id="downloadFile1" style="display:none;">
                                                                        <button class="btn btn-link csu-link" type="button" onclick="downloadFile1()"> ${supportingDocument.fileName}</button>
                                                                    </div>
                                                                    <div id="viewFile1" >
                                                                        <g:if test="${supportingDocument.mimeType == 'application/msword'}">
                                                                           <button id="downloadFileLink1" class="btn btn-link csu-link" type="button" type="button">${supportingDocument.fileName}</button>
                                                                        </g:if>
                                                                        <g:else>
                                                                            <g:link controller="application" action="showdocument" class="btn btn-link csu-link" params="[guid: "${guid}", docId: "${supportingDocument.docId}"]" target="_blank" class="external">${supportingDocument.fileName}</g:link>
                                                                        </g:else>
                                                                    </div>
                                                            </div>
                                                        </g:if>
                                                    </g:each>
                                                </g:if> 
                                                <g:if test="${docProvidedSupSchool==0}">
                                                     <div id="doc1" class="">
                                                        <span>None provided</span>
                                                    </div>
                                                </g:if>
                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <hr>
                                                </div>
                                            </div>
                                         </div>
                            </g:if>

                             
                                <!-- endif for  mixed bag of requests -->

                                <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="firstName">Given name</label>
                                    </div>
                                     <div class="col-lg-9 col-md-6 col-sm-6 col-xs-6 pull-left">
                                        <span>${requestDetails.firstName}</span>
                                     </div>
                                </div>
                                <br>
                                <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="lastName">Family name</label>
                                    </div>
                                     <div class="col-lg-9 col-md-6 col-sm-6 col-xs-6 pull-left">
                                        <span>${requestDetails.lastName}</span>
                                     </div>
                                </div>
                                <br>
                                <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="emailAddress">Email address</label>
                                    </div>
                                     <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7">
                                        <span>${requestDetails.emailAddress}</span>
                                        <input type="hidden" id="email" name="email" value="${requestDetails.emailAddress}" />
                                         <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
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
                                        <label for="studentId">Student ID number</label>
                                    </div>
                                     <div class="col-lg-9 col-md-6 col-sm-6 col-xs-6 pull-left">
                                        <span>${requestDetails.studentId}</span>
                                     </div>
                                </div>
                                <br>
                                <div class="row">
                                    <div class="col-lg-3 col-md-5 col-sm-5 col-xs-5 text-right">
                                        <label for="courseName">Full course name</label>
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
                                        <label for="courseCode">Course code</label>
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
                            
                            <div class="row">
                                <div class="col-md-12 form-row text-center">
                                    <hr>
                                </div>
                            </div>
                              <div class="col-md-12 col-push-small">
                                        <div class="form-group">
                                            <label class="spcon-label" for="declaration">
                                                <input type="checkbox" name="declaration" id="declaration" class="btn btn-default btn-spacing" data-toggle="modal" data-backdrop="static" data-keyboard="false" placeholder="" required="true"/>
                                                <strong>Declaration and Submission</strong>
                                            </label>
                                        </div>      
                               </div>

                               <div class="col-md-12 col-push-small">
                                   <span>In submitting this form I declare that the information supplied in it and in any supporting documentation is correct and complete. I accept that my request will not be considered without providing relevant supporting documentation. I acknowledge that the provision of false or misleading information may result in the cancellation of my enrolment with immediate expulsion from the University.</span>
                               </div>
                            

                             <div class="new-row">              
                                    <div class="row modal-button-row">
                                         <div class="col-md-12 form-row text-center">
                                            <hr>
                                             <button type="button" id="cencel" class="btn btn-default btn-spacing pull-right" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                                                 Delete Request
                                             </button>
                                             <span id="loading" class="btn pull-left">
                                                <g:if test="${params.skipStep2 == 'true'}">
                                                    <a href="${createLink(action: 'editSubjects', params: [guid: guid, newRequest: newRequest])}" class="back-link">Back to step 1</a>
                                                </g:if>
                                                <g:elseif test="${params.fromStep2b == 'true'}">
                                                    <a href="${createLink(action: 'reasonResSchoolExemption', params: [guid: guid])}" class="back-link">Back to step 2b</a>
                                                </g:elseif>
                                                <g:else>
                                                    <a href="${createLink(action: 'editReason', params: [guid: guid, newRequest: newRequest])}" class="back-link">Back to step 2</a>
                                                </g:else>
                                                
                                             </span>
                                             
                                             <button type="button" id="saveAppSubmit" class="btn btn-app btn-spacing">
                                                 Submit Request
                                             </button>
                                             
                                          </div>
                                    </div>
                            </div>
                        </div>              
                    <!--  End Reason Selection Block -->
                    
                    
    </form>

     <div class="modal fade" id="cancelAppModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>You are about to delete your request.</p>
                        <p>Once it's deleted, you will lose all the detail you have provided so far.</p>
                        <p>Are you sure you want to continue?</p>
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

        <div class="modal fade" id="document1" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">CSU Medical Certificate</h4>
              </div>
              <div class="modal-body">
             
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
            <!-- /.modal-content -->
          </div>
          <!-- /.modal-dialog -->
        </div>
    </div>
  </div>
<!-- /.modal -->
 </body>
</html>
