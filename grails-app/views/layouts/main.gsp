<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="grails.util.Environment" %>
<!DOCTYPE html>
<html lang="en">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="author" content="DIT Charles Sturt University">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="0" />
    	<title><g:layoutTitle default="Special Consideration - Form"/></title>
		<asset:link rel="icon" href="favicon.ico" type="image/x-ico" />

		<!-- CSS -->
		<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Open+Sans" />
		<asset:stylesheet src="application.css"/>
		<!-- Applications Script/s -->
		<asset:javascript src="application.js"/>
		<g:layoutHead/>

		<script>
		if (typeof jQuery !== 'undefined') {
			(function($) {
				$.extend({
					getBaseUrl: function() {
							<g:if test="${Environment.isDevelopmentMode()}">
								return '/';
							</g:if>
							<g:else>
								return '/specialcons/';
							</g:else>
					}
				});
			})(jQuery);
		}
		</script>


	</head>

	<body>
		<div id="skiptocontent">
			<a href="#maincontent">Skip to main content</a> 
		</div>
        <!-- Google Tag Manager -->
        <noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-TR9R3J"
        height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push(
        {'gtm.start': new Date().getTime(),event:'gtm.js'}
        );var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','GTM-TR9R3J');</script> 
        <!-- End Google Tag Manager -->
        <nav class="navbar navbar-default">
          <div class="container-fluid">
            <div class="navbar-header" role="navigation">
              <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand visible-sm-block visible-xs-block" href="http://www.csu.edu.au" title="Charles Sturt University">
                 <asset:image src="CSU_logo_171.png" alt="Charles Sturt University logo"/>
              </a>
            </div>
            
            <div id="navbar" class="navbar-collapse collapse" role="navigation">
              <ul class="nav navbar-nav navbar-right">
                    <li><a href="http://futurestudents.csu.edu.au">Future Students</a></li>
                    <li><a href="http://www.csu.edu.au/staff//-links">Staff</a></li>
                    <li><a href="http://alumni.csu.edu.au">Alumni</a></li>
                    <li><a href="http://www.csu.edu.au/library/">Library</a></li>
                    <li><a href="http://www.csu.edu.au/about/organisational-structure/faculties-and-schools">Faculties &amp; Schools</a></li>
                    <li><a href="http://www.csu.edu.au/jobs/">Jobs</a></li>
                    <li><a href="http://www.csu.edu.au/news/">News</a></li>
                    <li><a href="http://www.csu.edu.au/about">About</a></li>
                    <li><a href="http://www.csu.edu.au/contacts">Contacts</a></li>
                    <li><a href="http://student.csu.edu.au">Student Portal <span class="glyphicon glyphicon-user" aria-hidden="true"></span></a></li>
              </ul>
            </div><!--/.nav-collapse -->
          </div>
        </nav>

	 	<header>
			<div class="branding visible-lg-block branding-header">
				<div class="logo vertical-line">
					<a href="http://www.csu.edu.au" title="Charles Sturt University">
						<asset:image src="CSU_logo_171.png" alt="Charles Sturt University logo"/>
					</a>
				</div>
				<div id="global-title-wrapper" class="hidden-title">
					<h1 id="global-title">Special Consideration Request Form</h1>
				</div>
			</div>
  		</header>

		<div id="page-content-container" class="container-fluid">
			<div class="row">

                <!-- Nav -->
                <div id="sidebar" class="hidden-sm hidden-xs col-md-2 collapse navbar-collapse">
                		<ul class="nav">
                			<g:if test="${controllerName == 'taskInbox'}">
                				<li><g:link controller="taskInbox" action="dsoAwaitingTask">Home</g:link></li>
                				<li><g:link controller="taskInbox" action="searchAssignee">Search for Requests</g:link></li>
	                			<li><g:link controller="taskInbox" action="index">Forward My Tasks</g:link></li>
                			</g:if>
                			<g:else>
	                			<li><a href="${AppUtils.getBaseUrl()}">Request for Special Consideration</a></li>
	                			<!-- <li><g:link controller="trackRequest" action="index">Track My Requests</g:link></li> -->
                			</g:else>
                		</ul>
                </div>

                <div id="main" class="col-sm-12 col-md-10">
                	<div id="main-nav">
                        <div class="pull-right">
                            <g:link controller="application" action="logout" class="back-link">Logout</g:link>
                        </div>
                	</div>
                    
                	<div id="page-content">
                		<div class="panel panel-default">
                                <div class="panel-app">
                                    <div class="panel-heading">
                                        <h2 class="panel-title">
                                            ${headerText? headerText : "Request for Special Consideration"}
                                        <span class="pull-right glyphicon glyphicon-briefcase glyphicon-app" aria-hidden="true"></span>
                                        </h2>
                                    </div>
                                    <div class="panel-body">
									   <main id="maincontent">	
                                        <g:layoutBody/>
									   </main>	
                                    </div>
                                </div>




                        </div> <!-- End panel div from nav template -->
                    </div> <!-- End page-content div from nav template -->
                </div> <!-- End main div from nav template -->


            </div>
        </div>

<footer>
<div class="branding row">
    <div class="logo col-lg-4 col-md-3 col-sm-4 col-xs-12">
        <a href="http://www.csu.edu.au" title="Charles Sturt University">
            <asset:image src="CSU_logo_171.png" alt="Charles Sturt University logo"/>
        </a>
    </div>
    <div class="social-media-links pull-right pull-left-sm">
        <a href="https://twitter.com/charlessturtuni" title="Charles Sturt University on Twitter">
            <asset:image src="social-icon-twitter.png" alt="Twitter logo"/>
        </a>
        <a href="https://facebook.com/charlessturtuni" title="Charles Sturt University on Facebook">
            <asset:image src="social-icon-facebook.png" alt="Facebook logo"/>
        </a>
        <a href="https://www.linkedin.com/edu/school?id=10222" title="Charles Sturt University on LinkedIn">
            <asset:image src="social-icon-linkedin.png" alt="LinkedIn logo"/>
        </a>
        <a href="https://youtube.com/user/CharlesSturtUni" title="Charles Sturt University on YouTube">
            <asset:image src="social-icon-youtube.png" alt="YouTube logo"/>
        </a>
        <a href="https://instagram.com/charlessturtuni" title="Charles Sturt University on Instagram">
            <asset:image src="social-icon-instagram.png" alt="Instagram logo"/>
        </a>
        <a href="https://www.google.com/+charlessturtuniversity" title="Charles Sturt University on Google">
            <asset:image src="social-icon-google.png" alt="Google logo"/>
        </a>
    </div>
</div>
<div class="container info">
    <div class="pull-left">
        <div class="links">
            <a href="">Help</a>
            <span class="seperator"></span>
            <a href="">Contact</a>
            <span class="seperator"></span>
            <a href="">Website Feedback</a>
            <span class="seperator"></span>
            <a href="http://www.csu.edu.au/about/legal">Disclaimer &amp; Copyright</a>
            <span class="seperator"></span>
            <a href="http://www.csu.edu.au/accessibility">Accessibility</a>
            <span class="seperator"></span>
            <a href="http://www.csu.edu.au/about/legal#privacy">Privacy</a>
        </div>
        <div>
            <p>Australia: 1800 334 733 | International: +61 2 6338 6077</p>
            <p>Charles Sturt University CRICOS 00005F</p>
        </div>
    </div>
    <div class="owner-info pull-right">
        <p>Authoriser: ED Marketing and ED Student Admin</p>
        <p>Maintainer: Web Strategy Office</p>
        <p>Date created: 20/04/2016</p>
        <p>Date modified: 20/04/2016</p>
    </div>
</div>
</footer>

</body>

</html>
