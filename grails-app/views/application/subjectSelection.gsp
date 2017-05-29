<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.utils.DateUtils" %>
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
   

    <asset:javascript src="application/subjectSelection.js"/>
</head>
<body>
    <div class="content app-main" role="main">
        <form id="scApplicationForm" action="${AppUtils.getBaseUrl()}application/save"  data-so-base-url="${AppUtils.getInteractUrl()}" method="POST" role="form" data-toggle="validator">
            <input type="hidden" name="guid" value="${guid}" />
            <input type="hidden" id="mode" name="mode" value="${mode}" />
            <input type="hidden" id="newRequest" name="newRequest" value="${newRequest}" />
            <input type="hidden" id="requestTotal" name="requestTotal" ${requestList? "value=${requestList.size()}" : "value=0"} />
            <input type="hidden" name="saveStep" value="SUBJECT" />
            <input type="hidden" id="getSessionDataAction" value="${AppUtils.getBaseUrl()}application/getSessionData" />
            <input type="hidden" id="setSessionDataAction" value="${AppUtils.getBaseUrl()}application/setSessionData" />
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-left">
                            <h3>Step 1. Select subjects and request types</h3>
                            <span class="step-content">Enter your request details. All fields are mandatory unless marked optional.</span>
                        </div>

                        <!-- Wizard steps -->
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-left" style="display:none">
                            <div class="pull-right">
                                <ul class="bootstrapWizard form-wizard">
                                    <li data-target="#step1" class="active">
                                    <span class="step">1</span>
                                    </li>
                                    <li data-target="#step2" class="">
                                        <span class="step active">2</span>
                                    </li>
                                    <li data-target="#step3" class="">
                                        <span class="step">3</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <!--  End Wizard steps -->

                    </div>
                </div>

                <div class="clearfix"></div>

                <div id="actionResponse" role="alert"></div>

                <div class="block clearfix">
                <g:if test="${requestList?.size == 0}">
                    <!--  Subject Selection Block -->
                    <div class="row form-row subjectSelection" id="subjectSelection0">
                        <hr class="subjectDivider" style="display: none;">
                        <!--  Subject List -->
                        <div class="form-row row">
                            <div class="form-group">
                                <div class="col-md-6 form-row">
                                    <label for="subject0">For my subject
                                    <div class="input-group">
                                        
                                        <input type="hidden" name="id0" id="id0" ${requestList? "value=${requestList.id[0]}" : "value=0"} />
                                        <select class="form-control col-md-6 input-group-help subjectSelect" name="subject0" id="subject0" required="true">
                                            <g:if test="${subjectList?.size() > 0}">
                                                    <option value="">Please select your subject</option>
                                                <g:each var="subject" in="${subjectList}">
                                                    <option data-subject="${subject.subjectCode}" data-term="${subject.termCode}" data-campus="${subject.campusCode}" data-mode="${subject.mode}" data-term-end-date="${subject.termEndDate}" census-date="${subject.census_date}" residential-school="${subject.residential_school}" 
                                                        value="${subject.subjectEnrolment}_${subject.termEndDate}">${subject.subjectDisplay}</option>
                                                </g:each>
                                            </g:if>
                                            <g:else>
                                                    <option value="">You have no eligible subjects</option>
                                            </g:else>
                                        </select>
                                        <div class="input-group-btn help-btn">
                                            <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                title='Subjects <a href="#" class="close" data-dismiss="alert">×</a>'
                                                data-toggle="popover"
                                                data-trigger="click"
                                                data-content="<p>The subject list shows your enrolled subjects that do not have a final grade.</p><p>Contact <a href='http://student.csu.edu.au/services-support/student-central' target='_blank' class='external'>Student Central</a> if you need more help.</p>"
                                                ></a>
                                        </div>
                                    </div></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-row row">
                            <div class="form-group">
                                <div class="col-md-6 form-row">
                                    <label for="requestType0">I need
                                    <div class="input-group">
                                        <select class="form-control col-md-6 input-group-help requestTypeSelect" name="requestType0" id="requestType0" required="true">
                                            <option value="">What do you need?</option>
                                            <option value="${Constants.REQUEST_TYPE_GP}">An extension past the end of session to complete an assignment, assessment or placement</option>
                                            <option value="${Constants.REQUEST_TYPE_EX_C}">An extension past the end of session to complete a compulsory residential school</option>
                                            <option value="${Constants.REQUEST_TYPE_SX}">A supplementary final exam </option>
                                            <option value="${Constants.REQUEST_TYPE_AW}">To withdraw from a subject after census date</option>
                                            <option value="${Constants.REQUEST_TYPE_EX_R}">An exemption or partial exemption from a compulsory residential school</option>
                                        </select>
                                        <div class="input-group-btn help-btn">
                                            <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                title='Request Type <a href="#" class="close" data-dismiss="alert">×</a>'
                                                data-toggle="popover"
                                                data-trigger="click"
                                                data-content="<p>The request types listed are the ones relevant to the subject you selected. For example, Exemption from Residential School is only displayed if the subject you selected has a compulsory residential school.</p><p>Contact <a href='http://student.csu.edu.au/services-support/student-central' target='_blank' class='external'>Student Central</a> if you need more help.</p>"
                                                ></a>
                                        </div>
                                    </div></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-row row hidden-row gp-row" id="gpRow0"> <!-- start -->
                            <div class="form-group">
                                <div class="col-md-6 form-row-mobile form-row">
                                    <label for="assessment0">For Assessment Item(s)</label><span class="small"><a class="subjectOutlineLink external" href="" target="_blank">Check in subject outline</a></span>
                                    <div class="input-group">
                                        <input type="text" maxlength="100" class="form-control input-group-help assessment" name="assessment0" id="assessment0" />
                                        <label id="counter0" class="pull-right exSmallText" for="counter">0/100</label>
                                        
                                        <div class="input-group-btn help-btn hidden-row" id="assessmentHelp0">
                                                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                    title='Assessment Items <a href="#" class="close" data-dismiss="alert">×</a>'
                                                    data-toggle="popover"
                                                    data-trigger="click"
                                                    data-content="<p>Enter details of the assessment item(s) you are requesting an extension for. For example, 'Assessment item 1' or 'All assessment items'.</p>"
                                                    ></a>
                                        </div>
                                        <div class="input-group-btn help-btn hidden-row" id="resiSchoolHelp0">
                                                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                    title='Residential Schools <a href="#" class="close" data-dismiss="alert">×</a>'
                                                    data-toggle="popover"
                                                    data-trigger="click"
                                                    data-content="<p>Enter additional details, such as the name of the residential school.</p>"
                                                    ></a>
                                        </div>
                                        
                                    </div>
                                </div>
                                <div class="col-md-4 form-row-mobile form-row ext-date">
                                    <label for="extensionDate0"> Proposed extension date</label>
                                    <div id="extensionDateDiv0" class="extension-date-div">
                                        <div class="input-group date">
                                            <input type="text" class="form-control extensionDate" name="extensionDate0" id="extensionDate0" />
                                            <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                            <div class="input-group-btn help-btn">
                                                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button" 
                                                    title='Proposed extension date <a href="#" class="close" data-dismiss="alert">×</a>'
                                                    data-toggle="popover"
                                                    data-trigger="focus"
                                                    data-content="<p>You can propose an extension date that is past the end of session AND more than 3 business days in the future.</p><p>If you need an extension date that is less than 3 business days in the future, please contact your <a href='http://student.csu.edu.au/services-support/student-central/faq?id=2692449' target='_blank' class='external'>Subject Coordinator</a> as soon as possible.</p>"
                                                    ></a>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div><!-- end -->
                        
                        <div class="row form-row hidden-row exr-row" id="exrRow0"> <!-- start -->
                            <div class="form-group">
                                <div class="col-md-6 form-row-mobile">
                                    <label for="assessment0">Details</label> <span class="small"></span>
                                    <g:select class="form-control selDetail" id="selDetail0" name="selDetail0" from="${ExemptionReason.values()}" optionKey="key"  noSelection="['':'Select the reason you request an exemption']" value=""/>
                                    
                                </div>
                            </div>
                        </div><!-- end -->
                        
                        <div class="row form-row removeButtonRow hidden-row">
                            <div class="col-md-12 form-row text-center">
                                <button type="button" id="removeSubject0" class="btn btn-default removeSubjectButton"${(subjectList?.size() == 0) ? " disabled" : ""}>
                                    <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> Remove this request
                                </button>
                            </div>
                        </div>
                    </div>
                    <!--  End Subject Selection Block -->
                </g:if>
                <g:else>
                    <g:each status="i" in="${requestList}" var="request">
                         <!--  Subject Selection Block -->
                        <div class="row form-row subjectSelection" id="subjectSelection${i}">
                            <hr class="subjectDivider" style="display: none;">
                            <!--  Subject List -->
                            <div class="form-row row">
                                <div class="form-group">
                                    <div class="col-md-6 form-row">
                                        <label for="subject${i}">For my subject
                                        <div class="input-group">
                                            <input  type="hidden" name="id${i}" id="id${i}" ${requestList? "value=${request.id}" : "value=0"} />
                                            <select class="form-control col-md-6 input-group-help subjectSelect" name="subject${i}" id="subject${i}" required="true" >
                                                <g:if test="${subjectList?.size() > 0}">
                                                        <option value="">Please select your subject</option>
                                                    <g:each var="subject" in="${subjectList}">
                                                        <option data-subject="${subject.subjectCode}" data-term="${subject.termCode}" data-campus="${subject.campusCode}" data-mode="${subject.mode}" data-term-end-date="${subject.termEndDate}" census-date="${subject.census_date}" residential-school="${subject.residential_school}"
                                                        value="${subject.subjectEnrolment}_${subject.termEndDate}" ${(request.crn == subject.crn) ? " selected" : ""}>${subject.subjectDisplay}</option>
                                                    </g:each>
                                                </g:if>
                                                <g:else>
                                                        <option value="">You have no eligible subjects</option>
                                                </g:else>

                                            </select>
                                            <div class="input-group-btn help-btn">
                                                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                    title='Subjects <a href="#" class="close" data-dismiss="alert">×</a>'
                                                    data-toggle="popover"
                                                    data-trigger="click"
                                                    data-content="<p>The subject list shows your enrolled subjects that do not have a final grade.</p><p>Contact <a href='http://student.csu.edu.au/services-support/student-central' target='_blank' class='external'>Student Central</a> if you need more help.</p>"
                                                    ></a>
                                            </div>
                                        </div></label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row row">
                                <div class="form-group">
                                    <div class="col-md-6 form-row">
                                        <label for="requestType${i}">I need
                                        <div class="input-group">
                                            <select class="form-control col-md-6 input-group-help requestTypeSelect" name="requestType${i}" id="requestType${i}" required="true" >
                                                <option value="">What do you need?</option>
                                                <option value="${Constants.REQUEST_TYPE_GP}" ${(request.requestType == Constants.REQUEST_TYPE_GP) ? " selected" : ""}>An extension past the end of session to complete an assignment, assessment or placement</option>
                                                <option value="${Constants.REQUEST_TYPE_EX_C}" ${(request.requestType == Constants.REQUEST_TYPE_EX_C) ? " selected" : ""}>An extension past the end of session to complete a compulsory residential school</option>
                                                <option value="${Constants.REQUEST_TYPE_SX}" ${(request.requestType == Constants.REQUEST_TYPE_SX) ? " selected" : ""}>A supplementary final exam</option>
                                                <option value="${Constants.REQUEST_TYPE_AW}" ${(request.requestType == Constants.REQUEST_TYPE_AW) ? " selected" : ""}>To withdraw from a subject after census date</option>
                                                <option value="${Constants.REQUEST_TYPE_EX_R}" ${(request.requestType == Constants.REQUEST_TYPE_EX_R) ? " selected" : ""}>An exemption or partial exemption from a compulsory residential school</option>
                                            </select>
                                            <div class="input-group-btn help-btn">
                                                <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button"
                                                    title='Request Type <a href="#" class="close" data-dismiss="alert">×</a>'
                                                    data-toggle="popover"
                                                    data-trigger="click"
                                                    data-content="<p>The request types listed are the ones relevant to the subject you selected. For example, Exemption from Residential School is only displayed if the subject you selected has a compulsory residential school.</p><p>Contact <a href='http://student.csu.edu.au/services-support/student-central' target='_blank' class='external'>Student Central</a> if you need more help.</p>"
                                                    ></a>
                                            </div>
                                        </div></label>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- start -->
                            <g:if test="${request.requestType == Constants.REQUEST_TYPE_GP || request.requestType == Constants.REQUEST_TYPE_EX_C}">
                            	<div id="gpRow${i}" class="row form-row gp-row" >
                            </g:if>
                            <g:else>
                            	<div id="gpRow${i}" class="row form-row gp-row hidden-row" >
                            </g:else>
                                <div class="form-group">
                                    <div class="col-md-6 form-row-mobile">
                                        <label for="assessment${i}">Details</label> 
                                        <!--
                                        <g:if test="${request.requestType == Constants.REQUEST_TYPE_EX_C}">
                                        	<label class="optional" for="optional">(Optional)</label> 
                                        </g:if>
                                        <g:else>
                                        	<label class="optional" style="display:none">(Optional)</label> 
                                        </g:else>
                                        -->
                                        <span class="small"><a class="subjectOutlineLink external" href="" target="_blank">Check in subject outline</a></span>
                                         <g:if test="${request.requestType == Constants.REQUEST_TYPE_GP || request.requestType == Constants.REQUEST_TYPE_EX_C}">
                                         	<input type="text" class="form-control assessment" name="assessment${i}" id="assessment${i}" value="${request.assessmentItem}"/>
                                         </g:if>
                                         <g:else>
                                        	<input type="text" class="form-control assessment" name="assessment${i}" id="assessment${i}" value=""/>
                                         </g:else>
                                         <label id="counter${i}" class="pull-right exSmallText" for="counter">0/100</label>
                                    </div>

                                    <g:if test="${request.requestType == Constants.REQUEST_TYPE_EX_C}">
                                    	<div class="col-md-4 form-row-mobile ext-date hidden-row">
                                    </g:if>
                                    <g:else>
                                    	<div class="col-md-4 form-row-mobile ext-date">
                                    </g:else>
                                        <label for="extensionDate${i}"> Proposed extension date</label>
                                        <div id="extensionDateDiv${i}" class="extension-date-div">
                                            <div class="input-group date">
                                                <input type="text" class="form-control extensionDate" name="extensionDate${i}" id="extensionDate${i}" value="${DateUtils.formatDate(request.extensionDate, 'dd/MM/yyyy')}"/>
                                                <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                                <div class="input-group-btn help-btn">
                                                    <a tabindex="0" class="glyphicon glyphicon-question-sign glyphicon-app help-btn has-popover" role="button" 
                                                        title='Proposed extension date <a href="#" class="close" data-dismiss="alert">×</a>'
                                                        data-toggle="popover"
                                                        data-trigger="focus"
                                                        data-content="<p>You can propose an extension date that is past the end of session AND more than 3 business days in the future.</p><p>If you need an extension date that is less than 3 business days in the future, please contact your <a href='http://student.csu.edu.au/services-support/student-central/faq?id=2692449' target='_blank' class='external'>Subject Coordinator</a> as soon as possible.</p>"
                                                        ></a>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                           <!-- end -->
                           
                           <div id="exrRow${i}" class="row form-row exr-row ${(request.requestType == Constants.REQUEST_TYPE_EX_R) ? '' : ' hidden-row'}"> <!-- start -->
                            <div class="form-group">
                                <div class="col-md-6 form-row-mobile">
                                    <label for="selDetail${i}">Details</label> <span class="small"></span>
                                    <g:select class="form-control selDetail" id="selDetail${i}" name="selDetail${i}" from="${ExemptionReason.values()}" optionKey="key"  noSelection="['':'Select the reason you request an exemption']" value="${request.assessmentItem}"/>
                                    
                                </div>
                            </div>
                        </div><!-- end -->
                        
                                <div class="row form-row removeButtonRow ${(i == 0) ? ' hidden-row' : ''}">
                                    <div class="col-md-12 form-row text-center">
                                        <button type="button" id="removeSubject${i}" class="btn btn-default removeSubjectButton"${(subjectList?.size() == 0) ? " disabled" : ""} >
                                            <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> Remove this request
                                        </button>
                                    </div>
                                </div>      
                                <g:if test="${i < requestList.size()-1}">
                                    <hr>
                                </g:if>              
                        </div>
                        <!--  End Subject Selection Block -->

                    </g:each>
                </g:else>
                    
                    <div id="addRows">
                    </div>

                    <div class="row form-row">
                        <div class="form-group text-center">
                            <div class="form-row addSubjectButton" id="tooltip-wrapper">
                                <button type="button" id="addSubject" class="btn btn-default"${(subjectList?.size() == 0) ? " disabled" : ""}>
                                    <span class="glyphicon glyphicon-plus" id="addSubjetIcon" aria-hidden="true"></span> Add another request
                                </button>
                            </div>
                        </div>
                    </div>
                    <hr>
                    

                   <div class="row form-row">
                        <div class="col-md-5 form-row text-center">
                            <button type="button" id="cancelApp" class="btn btn-default btn-spacing pull-right" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#cancelAppModal">
                                Delete Request
                            </button>
                        <button type="button" id="saveNextApp" class="btn btn-app btn-spacing" data-toggle="modal" data-backdrop="static" data-keyboard="false"
                                data-target="#confirmAppModal" ${(subjectList?.size() == 0) ? " disabled" : ""}>
                                &nbsp;&nbsp;&nbsp; Next &nbsp;&nbsp;&nbsp;
                            </button>
                        </div>
                    </div>

                </div>
            </form>
            
        <div class="modal fade" id="outsideTwelveMonths" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="dialog">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Extension date must be no later than 12 months after the End of Session, unless attendance at residential school or practicum is required.</p>
                        <input type="checkbox" id="postEndOfSession">Please don't display this message again.</input>
                        <div class="row modal-button-row">
                            <button type="button" class="btn btn-app btn-spacing" data-dismiss="modal">
                                Ok
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

         <div class="modal fade" id="closeToEndOfTheTerm" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="dialog">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>According to CSU Policy certain request types have<br> <a href='http://student.csu.edu.au/services-support/student-central/askcsu#/article/14759' target='_blank' class='external'>time limits for submission</a><br> Late applications may be accepted if circumstances<br> occurred preventing on time submission.<br> Please provide details in Step 2.</p>
                        <input type="checkbox" id="endOfTerm">Please don't display this message again.</input>
                        <div class="row modal-button-row">
                            <button type="button" class="btn btn-app btn-spacing" data-dismiss="modal">
                                Ok
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
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

        <div class="modal fade" id="confirmAppModal" tabindex="-1" role="dialog" aria-labelledby="confirmAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>Have you included <b>all subjects</b> and <b>request types</b> that you want to be considered at this time?</p>
                        <div class="row modal-button-row">
                            <div class="row">
                                <span id="loading" class="btn"></span>
                            </div>
                            <button type="button" id="saveAppNo" class="btn btn-default btn-spacing" data-dismiss="modal">
                                No
                            </button>
                            <button type="button" id="saveAppYes" class="btn btn-app btn-spacing">
                                Yes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

         <div class="modal fade" id="resiEXRRequest" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="dialog">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>If you need to make more than one request for:<br>“An exemption or partial exemption from a compulsory residential school”<br>
for the reason:<br>“I have completed the work to be taught at the<br> residential school previously”</p>
                        <p>You must create a separate <a href="${(Environment.isDevelopmentMode()) ? '/' : '/specialcons/'}application/start" target="_blank" class="external">new request</a></p>
                        <div class="row modal-button-row">
                            <button type="button" class="btn btn-app btn-spacing" data-dismiss="modal">
                                Ok
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
