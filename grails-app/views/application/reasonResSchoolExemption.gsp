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
    <asset:javascript src="application/reasonResSchoolExemption.js"/>
</head>
<body>
    <div class="content app-main" role="main">

        <g:uploadForm name="scApplicationReasonForm" elementId="scApplicationReasonForm" controller="application" action="save" method="POST">
            <input type="hidden" name="saveStep" value="EXEMPTION_RES_SCHOOL_REASON">
            <input type="hidden" id="saveForLater" name="saveForLater" value="false">
            <input type="hidden" name="guid" id="guid" value="${guid}" >
            <input type="hidden" id="mode" name="mode" value="${mode}" />
            <input type="hidden" id="newRequest" name="newRequest" value="${newRequest}" />
            <input type="hidden" id="fragment" name="fragment" value="${fragment}" />
            <input type="hidden" id="skipStep2a" name="skipStep2a" value="${params.skipStep2a}" />
			
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pull-left">
                    	<g:if test="${params.skipStep2a == 'true'}">
                    		<h3>Step 2. Provide details and supporting documents</h3>
                    	</g:if>
                    	<g:else>
                    		<h3>Step 2b. Provide details and supporting documents</h3>
                    	</g:else>
                        <span class="step-content">All fields are mandatory unless marked optional.</span>
                    </div>
                </div>
            </div>

            <div class="clearfix"></div>
            <div id="actionResponse" role="alert"></div>            
            <div class="block clearfix">
                <div class="row form-row" id="descRow">
                    <div class="form-group">
                        <div class="col-md-11 form-row">
                        <div class="step-heading" id="suppDocs">
                            Please provide specific details for your request
                        </div>
                             <div class="col-lg-9 col-md-7 col-sm-7 col-xs-7 text-left">
                                 <g:if test="${subjectList?.size() > 0}">
                                    <g:each var="subject" in="${subjectList}">
                                        <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'COMPLETED'}">
                                            <input type="hidden" name="requestid" id="requestid" value="${subject.requestId}" >
                                            <div>
                                                <span>${subject.subjectDisplay}:</span>
                                                <div>
                                                    <span>${subject.requestType}</span>
                                                </div>
                                                <span>"${ExemptionReason.COMPLETED}"</span>
                                                <br>
                                            </div>
                                        </g:if>
                                    </g:each>
                                </g:if>
                             </div>
                        </div>
                    </div>
                </div>
                <!--  End Reason Selection Block -->
            <div class="row form-row" id="descRow">
                    <div class="form-group">
                        <div class="col-md-11 form-row">                        
                            <div class="input-group col-md-11">
                                <textarea rows="5" maxlength="500" class="form-control" name="descText" id="descriptionText" placeholder="" required="true" >${subjectList? subjectList[0].reasonText : ""}</textarea>
                                    <label id="counter" class="text-right pull-right exSmallText" for ="counter">0/500</label>
                            </div>
                        </div>
                    </div>
                </div>
                
            </div>
            <hr class="hr-divider"/>
            
            <div class="block clearfix">
                <div class="step-heading" id="suppDocs">
                    Supporting documents (optional)
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
                    <div class="col-lg-2 col-md-3 col-sm-6 col-xs-6">
                        <label for="documentFile1" class="spcon-label-horiz spcon-label">Supporting document</label>
                    </div>
                    <div class="col-lg-7 col-md-5 col-sm-4 col-xs-4">
                        <div id="file-tooltip">
                            <g:field id="documentFile1" name="documentFile1" type="file" data-initial-caption="${documentList? documentList[0].fileName : ''}" data-initial-file="${documentList? documentList[0].fileName : ''}" />
                        </div>
                        <p id="fileError0" data-error=""></p>
                        <input type="hidden" id="removeDoc01Flag" name="removeDoc01Flag" value="false">
                        <input type="hidden" id="doc01Id" name="doc01Id" value="${documentList? documentList[0].docId : '0'}">
                    </div>
                </div>            
            <br>
            <hr class="hr-divider"/>

            <div class="block clearfix">
                <div class="row modal-button-row">
                     <div class="col-md-12 form-row text-center">
                        <div class="row">
                            <span id="loading" class="btn"></span>
                        </div>
                        <button type="button" id="cancel" class="btn btn-default btn-spacing pull-right" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                             Delete Request
                         </button>
                         <button id="stepBack" class="btn btn-link pull-left back-link">
                         	<g:if test="${params.skipStep2a == 'true'}">
                         		Back to step 1
                         	</g:if>
                         	<g:else>
                         		Back to step 2a
                         	</g:else>
                         </button>
                         <button type="button" id="saveNextApp" class="btn btn-app btn-spacing">
                             Next 
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
                    
    </div>
</body>
</html>
