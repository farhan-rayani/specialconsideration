<%@ page import="grails.util.Environment" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <asset:javascript src="application/index.js"/>
    <title>Request for Special Consideration - Special Consideration Request Form</title>
</head>
<body>
    <div class="content col-md-12 col-sm-12 col-xs-12" role="main">
        <input type="hidden" id="uri" value="${(Environment.isDevelopmentMode()) ? '' : '/specialcons/'}application/start" />
        <h3 class="app-heading col-lg-12 col-md-12 col-sm-12 col-xs-12">Instructions</h3>

        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-left">
            <p>
                Use this form to advise the University that special circumstances have occurred which may
                affect your ability to undertake your studies or complete assessment tasks in your subject(s) by end of session.
                This includes seeking exemption from compulsory residential schools.
            </p>
            <p>
                <span class="glyphicon glyphicon-exclamation-sign" style="color: black;"></span><strong> DO NOT </strong> use this form if: 
            </p>
            <p>
          <ul class="pad-left-15px">
            <li>You have been granted a <a href="http://student.csu.edu.au/services-support/student-central/faq?id=2692448">final substantive grade.</a> Please complete a
            <a href="http://student.csu.edu.au/administration/forms/Review-of-Grade-Request.pdf">Review of Grade form</a> instead.
            </li>
            <br>
            <li>You are seeking a short extension for an assessment task that will be completed within the session. Contact your  
                <a href='http://student.csu.edu.au/services-support/student-central/faq?id=2692449'>Subject Coordinator</a> directly for these requests.
            </li>
            <br>
            <li>You are seeking to withdraw from subjects before census date. You can delete the subjects on-line by visiting   
                <a href="https://online.csu.edu.au/Inter/Action?type=B&amp;cmd=Check_PIN&amp;system=Enrolment_Menu ">Online Administration.</a>
            </li>
         </ul>
         </p>
          <br>
          
            <p>For further information on Special Consideration:</p>
            <p>
                <ul class="pad-left-15px">
                    <li><a href="http://student.csu.edu.au/services-support/student-central/faq?id=2543086" target="_blank" class="external">AskCSU FAQs</a> </li>
                    <li><a href="https://policy.csu.edu.au/view.current.php?id=00301" target="_blank" class="external">Assessment Policy — Coursework Subjects</a></li>
                    <li><a href="https://policy.csu.edu.au/view.current.php?id=00298" target="_blank" class="external">Special Consideration Policy</a></li>
                    <li><a href="http://student.csu.edu.au/home/about/legal#privacy" target="_blank" class="external">Privacy and Personal Information at CSU</a></li>
                </ul>
            </p>
        </div>
       
              
            <!-- <p>
                Further information regarding the Privacy and Personal Information Protection Act 1998 (NSW) and the Health
                Records and Information Privacy Act 2002 (NSW).
            </p> -->
        
        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center" style="margin-top: 10px;">
            <a id="startRequestBtn" href="${(Environment.isDevelopmentMode()) ? '' : '/specialcons/'}application/start" class="btn btn-app">Start New Request</a> 
            <!-- <button id="startRequestBtn" type="button" class="btn btn-app btn-spacing">Start New Request</button> -->
        </div>
    </div>
    <div class="modal fade" id="browserWarningModal" tabindex="-1" role="dialog" aria-labelledby="cancelAppModalLabel">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog confirm-modal vertical-align-center" role="document">
                    <div class="modal-content confirm-modal-content text-center">
                        <!--
                        <p>We recommend using the latest version of Chrome, Firefox or Safari for this application.</p>
                        <p>Do you still want to proceed using the current browser?</p>
                        -->
                        <p>For best performance, we recommend you use the latest version of Chrome or Safari</p>
                        <div class="row modal-button-row">
                            <button type="button" class="btn btn-app btn-spacing" data-dismiss="modal">
                                Ok
                            </button>
                            <!--
                            <button type="button" id="continueAppNo" class="btn btn-app btn-spacing" data-dismiss="modal">
                                No
                            </button>
                            <button type="button" id="continueAppYes" class="btn btn-default btn-spacing">
                                Yes
                            </button>
                            -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>
