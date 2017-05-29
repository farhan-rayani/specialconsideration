<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Request for Special Consideration - Special Consideration Request Form</title>

    <asset:stylesheet src="fileinput.min.css"/>
    <asset:javascript src="bootstrap-fileinput/plugins/canvas-to-blob.min.js"/>
    <asset:javascript src="bootstrap-fileinput/plugins/sortable.min.js"/>
    <asset:javascript src="bootstrap-fileinput/plugins/purify.min.js"/>
    <asset:javascript src="bootstrap-fileinput/fileinput.js"/>
    <asset:javascript src="bootstrap-fileinput/fileinput.min.js"/>
    <asset:javascript src="application/complete.js"/>
</head>
<body>
    <div class="content app-main" role="main">

        <form id="scApplicationForm" action="${AppUtils.getBaseUrl()}application/save" method="POST" role="form" data-toggle="validator">
            <input type="hidden" name="saveStep" value="COMPLETE" />
            <input type="hidden" name="guid" value="${guid}" />



                <div class="container-fluid">
                    <div class="row">
                       <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pull-left">
                            
                        </div>
                        <!-- Wizard steps -->

                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="pull-right">
                                <ul class="bootstrapWizard form-wizard">
                                    <li data-target="#step1" class="active">
                                        <span class="step active">1</span></a>
                                    </li>
                                    <li data-target="#step2" class="active">
                                        <span class="step active">2</span></a>
                                    </li>
                                    <li data-target="#step3" class="active">
                                        <span class="step active">3</span></a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="clearfix"></div>

                <div id="actionResponse" role="alert"></div>

                <div class="block clearfix">
                        <div class="" id="request">
                          		<div class="row">
	                            	<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
	                            		<p><label><strong>Your request for Special Consideration has been submitted successfully.</strong></label></p><br>
                                        <p><span>A confirmation email has been sent to your email address ${email}</span></p>
                                        <p><span>You should expect an outcome within 20 business days.</span></p>
                                        <p><span>If you have any enquiries regarding your request please contact <g:link url="http://www.csu.edu.au/student/central/" target='_blank' class='external'>Student Central</g:link></span><br></p>
	                                </div>
                                </div>
                        </div>
                </div>
	                                 
		             <div class="new-row">  			
		                    <div class="row modal-button-row">
		                         <div class="col-md-12 form-row text-center">
			                         <button type="button" id="close" class="btn btn-app btn-spacing">
			                             Close
			                         </button>
			                      </div>
		                    </div>
		                </div>
		         </div>    
	</form>

    <div class="modal fade" id="backAppModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <p>You have already submitted your form and you cannot go back after submission.</p>
                        <p>If you need to review your submitted request details, please refer to the confirmation email which has been sent to ${email}</p>
                        <div class="row modal-button-row">
                            <button type="button" class="btn btn-app btn-spacing" data-dismiss="modal">
                                Ok
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>
