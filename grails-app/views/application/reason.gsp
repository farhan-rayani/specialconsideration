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
    <asset:stylesheet src="fileinput.css"/>
    <asset:javascript src="bootstrap-fileinput/plugins/canvas-to-blob.min.js"/>
    <asset:javascript src="bootstrap-fileinput/plugins/sortable.min.js"/>
    <asset:javascript src="bootstrap-fileinput/plugins/purify.min.js"/>
    <asset:javascript src="bootstrap-fileinput/fileinput.js"/>
    <asset:javascript src="bootstrap-fileinput/fileinput.min.js"/>
    <asset:javascript src="application/reason.js"/>
</head>
<body>
    <div class="content app-main" role="main">

        <g:uploadForm name="scApplicationReasonForm" elementId="scApplicationReasonForm" controller="application" action="save" method="POST">
            <input type="hidden" name="saveStep" value="REASON">
            <input type="hidden" id="saveForLater" name="saveForLater" value="false">
            <input type="hidden" name="guid" id="guid" value="${guid}" >
            <input type="hidden" id="mode" name="mode" value="${mode}" />
            <input type="hidden" id="newRequest" name="newRequest" value="${newRequest}" />
            <input type="hidden" id="fragment" name="fragment" value="${fragment}" />
			<input type="hidden" id="showStep2b" name="showStep2b" value="${showStep2b}" />
			
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-left">
                    	<g:if test="${showStep2b == true}">
                    		<h3>Step 2a. Select reason and provide supporting documents</h3>
                    	</g:if>
                    	<g:else>
                        	<h3>Step 2. Select reason and provide supporting documents</h3>
                        </g:else>
                        <span class="step-content">All fields are mandatory unless marked optional.</span>
                    </div>

                    <!-- Wizard steps -->
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="display:none">
                        <div class="pull-right"> 
                            <ul class="bootstrapWizard form-wizard">
                                <li data-target="#step1" class="">
                                    <span class="step">1</span>
                                </li>
                                <li data-target="#step2" class="active">
                                    <span class="step active">2</span>
                                </li>
                                <li data-target="#step3" class="">
                                    <span class="step">3</span>
                                </li>
                            </ul>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                    <!--  End Wizard Steps -->
                </div>
            </div>

            <div class="clearfix"></div>

            <div id="actionResponse" role="alert"></div>
			<g:if test="${ciVisible == 1}">
				<div class="col-xs-12 alert alert-warning critical-warning">
	                <div>     
		               	<div class="glyphicon glyphicon-exclamation-sign"></div>
		               	<div class="critical-incident-label">Critical Incident</div>
		                   <div class="critical-incident-text"> 
		                    	If you have been affected by <strong>${incident}</strong> please select Critical Incident as the reason for your request, and enter details. Supporting documents are <strong>optional</strong> in this case.
		                   </div>
					</div>	
	            </div>
            </g:if>
            <div class="block clearfix">
            	
                <div class="step-heading">
                    What is the main reason for your request?
                </div>
				
				<g:if test="${showSubjects}">
		            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8 subject-info">
		            	<g:each var="subject" in="${subjectList}">
			                <div>     
				               <div>${subject.subjectDisplay}:</div>
				               	  <div>
			               			${subject.requestType} 
			               			<g:if test="${subject.assessmentItem}">
			               				<br/>
			               				<g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'CANT_COMPLETE'}">
			               					"${ExemptionReason.CANT_COMPLETE}"
			               				</g:if>
			               				<g:elseif test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'PASSED'}">
			               					"${ExemptionReason.PASSED}"
			               				</g:elseif>
			               				<g:else>
			               					"${subject.assessmentItem}"
			               				</g:else>
			               			</g:if>
			               			<g:if test="${subject.extensionDate}">
			               				by ${subject.extensionDate}
			               			</g:if>
			               		</div>
							</div>	
							<br>
					    </g:each>	
		            </div>
               </g:if>
            
                <div class="row form-row reasonSelection">
                    <div class="form-group">
                       <div class="col-md-11">
                        <label for="reasonType" class="spcon-label"></label>
                            <div class="input-group col-md-11">
                            <input type="hidden" id="reason" name="reason" value="${requestList? requestList[0].requestReason : ''}" />
                            <select class="form-control input-group-help reasonSelect" name="reasonType" id="reasonType" required="true" >
                                <option value="">Select the reason for your request</option>
                                <g:if test="${ciVisible == 1}">
                                	<option value="${Constants.REASON_TYPE_CI}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_CI}") ? " selected" : ""}>Critical Incident</option>
                                </g:if>
                                <option value="${Constants.REASON_TYPE_MED_ABI}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_MED_ABI}") ? " selected" : ""}>Medical reasons - Acute/brief illness</option>
                                <option value="${Constants.REASON_TYPE_MED_EI}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_MED_EI}") ? " selected" : ""}>Medical reasons - Extended illness</option>
                                <option value="${Constants.REASON_TYPE_FPR}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_FPR}") ? " selected" : ""}>Family/personal reasons</option>
                                <option value="${Constants.REASON_TYPE_ER}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_ER}") ? " selected" : ""}>Employment related</option>
                                <option value="${Constants.REASON_TYPE_AI}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_AI}") ? " selected" : ""}>Administrative Issues</option>
                                <option value="${Constants.REASON_TYPE_RC}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_RC}") ? " selected" : ""}>Representative commitments</option>
                                <option value="${Constants.REASON_TYPE_MC}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_MC}") ? " selected" : ""}>Military commitments</option>
                                <option value="${Constants.REASON_TYPE_LC}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_LC}") ? " selected" : ""}>Legal commitments</option>
                                <option value="${Constants.REASON_TYPE_OE}" ${requestList && (requestList[0].requestReason == "${Constants.REASON_TYPE_OE}") ? " selected" : ""}>Other events</option>
                            </select>
                           </div>

                           <div class="row onScreenTextRow" id="onScreenTextRow">
                                <div class="form-group">
                                    <div class="col-md-11">
                                        <div class="hidden-row ABI" id="ABI">
                                            <br>
                                            <p>
                                                Medical certificates must be completed in the form of a <g:link url="http://student.csu.edu.au/administration/forms/CSU-Student-Medical-Certificate.pdf" target='_blank' class='external' data-lightbox-title="Ask CSU">CSU Medical Certificate</g:link> Where other documentation from a health care provider is used, it must contain the information required by the <strong>CSU medical certificate</strong>, including the impact of the condition upon your ability to complete the subject.
                                            </p>
                                        </div>
                                        <div class="hidden-row EI" id="EI">
                                            <br>
                                            <p>
                                                You must provide a <g:link url="http://student.csu.edu.au/administration/forms/CSU-Student-Medical-Certificate.pdf" target='_blank' class='external'>CSU Medical Certificate</g:link> or a <strong>medical report</strong>, which is a signed statement from a qualified and registered health practitioner explaining the debilitating nature of the chronic (ongoing) medical condition from which you are/were suffering and the likely duration of the condition. It must include the precise nature of the medical condition, unless to do so would result in a breach of patient confidentiality.
                                            </p>
                                        </div>
                                        <div class="hidden-row FPR" id="FPR">
                                            <br>
                                            <p>
                                                Including death or severe medical or personal problems.
                                                You must provide a <strong>statement from a registered health care practitioner</strong>, a recognised mental health professional, or a person who knows you but not related to you and is independent of the university stating the date of the change to your personal circumstances, and how these circumstances affect your ability to study.
                                            </p>
                                        </div>
                                        <div class="hidden-row ER" id="ER">
                                            <br>
                                            <p>
                                                Such as a substantial change to routine employment arrangements or status.
                                                You must provide a <strong>statement from your employer</strong> stating the date of the change to your employment arrangements or status, and the nature of the changes.
                                            </p>
                                        </div>
                                        <div class="hidden-row AI" id="AI">
                                            <br>
                                            <p>
                                               Such as the late receipt of teaching materials, enrolment errors, or delays.
                                               You must provide a <strong>statement from the relevant authority</strong> advising the details of the issues.
                                            </p>
                                        </div>
                                        <div class="hidden-row RC" id="RC">
                                            <br>
                                            <p>
                                                If you have been selected to participate in a state, national or international sporting or cultural event. You must provide a <strong>statement from the relevant authority</strong> advising the details of the event and the period of interruption to your study.
                                            </p>
                                        </div>
                                         <div class="hidden-row MC" id="MC">
                                             <br>
                                            <p>
                                            If you are a member of the armed forces involved in a compulsory exercise.
                                            You must provide a <strong>statement from the relevant authority</strong> advising the details of the exercise and the period of interruption to your study.
                                            </p>
                                        </div>
                                        <div class="hidden-row LC" id="LC">
                                            <br>
                                            <p>
                                            If you are called for jury duty or subpoenaed to attend a court, tribunal, etc.
                                            You must provide a <strong>statement from the relevant authority</strong> advising the details of the event and the period of interruption to your study.
                                            </p>
                                        </div>
                                        <div class="hidden-row OE" id="OE">
                                            <br>
                                            <p>
                                            That pose a major obstacle to you proceeding satisfactorily your studies.
                                            You must provide a <strong>statement from the relevant authority</strong> advising the details of the events and how these events affect your ability to study.
                                            </p>
                                        </div>
                                        
                                         <div class="hidden-row CI" id="CI">
                                            <br>
                                            <p>
                                           Please use this option only if you have been affected by <strong>${incident}</strong>. Please enter details below. 
                                           Supporting documents are <strong>optional</strong> in this case.

                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row form-row" id="descRow">
                    <div class="form-group">
                        <div class="col-md-11 form-row">
                            <label for="descText" class="spcon-label">Please provide details of the reason for your request</label>
                            <div class="input-group col-md-11">
                                <textarea rows="5" maxlength="500" class="form-control" name="descText" id="descriptionText" placeholder="" required="true" >${requestList? requestList[0].reasonText : ""}</textarea>
                                    <label id="counter" class="text-right pull-right exSmallText" for="counter">0/500</label>
                            </div>
                        </div>
                    </div>
                </div>
                <!--  End Reason Selection Block -->

                <div class="row form-row" style="display:none">
                    <div class="form-group col-md-12">
                        <input name="counselling" type="checkbox" id="counselling" ${(requestList && requestList[0].counselling == 1)? "checked=true" : ""}>
                            <label class="spcon-label" for="counselling">
                                I would like the Academic Support and Advice Team to contact me regarding counselling services
                            </label>
                   </div>
                </div>
            </div>

            <hr class="hr-divider"/>
            
            <div class="block clearfix">
                <div class="step-heading" id="suppDocs">
                    Supporting documents <span class="critical-warning ci-show">(Optional)</span>
                    <span class="small ci-hide">  
                        <a id="askCSULink"  
                         href=' http://student.csu.edu.au/services-support/student-central/faq?id=2675736' target='_blank' class='external' class="subjectOutlineLink">What can I provide?</a></span>
                </div>

                <div class="row ci-hide">
                    <div class="col-md-12">
                        <p><strong>Please upload mandatory supporting documentation.</strong> You can also upload up to two additional supporting documents.</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
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
                    <label class="col-lg-3 col-md-6 col-sm-8 col-xs-8 spcon-label-horiz spcon-label ci-hide" for="documentFile1">Mandatory supporting document</label>
                    <label class="col-lg-3 col-md-6 col-sm-8 col-xs-8 spcon-label-horiz spcon-label ci-show" for="documentFile1">Supporting document</label>
                    <div class="col-lg-9 col-md-6 col-sm-4 col-xs-4">
                        <div id="file-tooltip">
                            <g:field id="documentFile1" name="documentFile1" type="file" data-initial-caption="${documentList? documentList[0].fileName : ''}" data-initial-file="${documentList? documentList[0].fileName : ''}"/>
                        </div>
                        <span id="checkBoxMsg" class="col-lg-9 col-md-6 col-sm-4 col-xs-4 text-success hidden">By attaching a mandatory supporting document, 'I will provide mandatory supporting documentation within 14 days' has been unchecked.</span>
                        <p id="fileError0" data-error=""></p>
                        <input type="hidden" id="removeDoc01Flag" name="removeDoc01Flag" value="false">
                        <input type="hidden" id="doc01Id" name="doc01Id" value="${documentList? documentList[0].docid : '0'}">
                    </div>
                </div>

                <div id="supportDocument1" class="row form-row supportDocument1 form-group ${(mode == 'edit' && documentList?.size() > 1) ? '' : ' hidden-row'}" >
                    <label class="col-lg-3 col-md-6 col-sm-8 col-xs-8 spcon-label-horiz spcon-label" for="documentFile2"> Additional Supporting Document </label>
                    <div class="col-lg-9 col-md-6 col-sm-4 col-xs-4">
                        <div>
                            <g:field id="documentFile2" name="documentFile2" type="file" data-initial-caption="${(mode == 'edit' && documentList?.size() > 1)? documentList[1].fileName : ''}"/>
                        </div>
                        <p id="fileError1" class="help-block" data-error=""></p>
                        <input type="hidden" id="removeDoc02Flag" name="removeDoc02Flag" value="false">
                        <input type="hidden" id="doc02Id" name="doc02Id" value="${(mode == 'edit' && documentList?.size() > 1)? documentList[1].docid : '0'}">
                    </div>
                </div>

                <div id="supportDocument2" class="row form-row supportDocument1 form-group ${(mode == 'edit' && documentList?.size() > 2) ? '' : ' hidden-row'}" >
                    <label class="col-lg-3 col-md-6 col-sm-8 col-xs-8 spcon-label-horiz spcon-label" for="documentFile3"> Additional Supporting Document </label>
                    <div class="col-lg-9 col-md-6 col-sm-4 col-xs-4">
                        <div>
                            <g:field id="documentFile3" name="documentFile3" type="file" data-initial-caption="${mode == 'edit' && documentList?.size() > 2? documentList[2].fileName : ''}"/>
                        </div>
                        <p id="fileError2" class="help-block" data-error=""></p>
                        <input type="hidden" id="removeDoc03Flag" name="removeDoc03Flag" value="false">
                        <input type="hidden" id="doc03Id" name="doc03Id" value="${(mode == 'edit' && documentList?.size() > 2)? documentList[2].docid : '0'}">
                    </div>
                </div>

                <div class="row form-row">
                    <div class="form-group text-center">
                        <div class="form-row addDocumentButton" id="tooltip-addDoco">
                            <button type="button" id="addDocument" class="btn btn-default" ${(mode == 'edit' && documentList?.size() < 3) ? '' : ' disabled'}>
                                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span> Add another document
                            </button>
                        </div>
                        <div class="form-row addDocumentButton ${(mode == 'edit' && documentList?.size() > 1) ? '' : ' hidden'}" id="removeDocoDiv">
                            <button type="button" id="removeDocument" class="btn btn-default">
                                <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> Remove additional document
                            </button>
                        </div>
                    </div>
                </div>
               
                <div class="row form-row" style="display:none">
                    <div class="col-md-12">
                        <label class="spcon-label" id="tooltip-wrapper" for="supportDocLater"> 
                            <input name="supportDocLater" type="checkbox" id="supportDocLater" ${(((requestList && requestList[0].requestReason != null && documentList?.size() == 0 )))? "checked" : ""}>  
                            I will provide mandatory supporting documentation within 14 days.
                        </label>
                    </div>
                    <div class="col-md-12 text-left">
                        <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span><span class="small help-text">Please note that your form won't be processed until you provide relevant supporting documentation.</span>
                    </div>
                </div>
            

            <hr class="hr-divider"/>

            <div class="clearfix">
                <div class="row modal-button-row">
                     <div class="col-md-12 form-row text-center">
                        <div class="row">
                                <span id="loading" class="btn"></span>
                        </div>
                         <button type="button" id="cancel" class="btn btn-default btn-spacing pull-right" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                             Delete Request
                         </button>
                         <button id="stepBack" class="btn btn-link pull-left back-link">Back to step 1</button>
                         <button style="display:none" type="button" id="saveAppYes" class="btn btn-default btn-spacing" data-dismiss="modal" data-backdrop="static" data-keyboard="false">
                             Save for Later
                         </button>
                         
                         <button type="button" id="saveNextApp" class="btn btn-app btn-spacing">
                             &nbsp;&nbsp;&nbsp; Next &nbsp;&nbsp;&nbsp;
                         </button>
                         
                      </div>
                </div>
            </div>

        </g:uploadForm>

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

        <div class="modal fade" id="errorAppModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Before you can proceed, you must complete the mandatory fields where indicated, and provide the mandatory supporting document.</p>
                        <div class="row modal-button-row">
                            <button type="button" id="okError" class="btn btn-app btn-spacing" data-dismiss="modal">
                                Close
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <g:if test="${!Environment.isDevelopmentMode()}">
            <div id="askCSU" class="modal fade" role="dialog">
                <div class="modal-dialog modal-lightbox">
                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Ask CSU</h4>
                        </div>
                        <div class="modal-body">
                            <iframe class="modal-lightbox-body" frameborder="0" allowfullscreen=""></iframe>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </g:if>
                    
    </div>
</body>
</html>
