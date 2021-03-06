<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<%@ page import="au.edu.csu.specialcons.enumstudent.ExemptionReason"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
    <head>
        <title>${emailSubject}</title>
        <style type="text/css">
        
    </style>
    </head>
    <body>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td bgcolor="#FFFFFF">
            <!-- HIDDEN PREHEADER TEXT -->
                <div style="display: none; font-size: 1px; color: #FFFFFF; line-height: 1px; font-family: Helvetica, Arial, sans-serif; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;">
                    Charles Sturt University
                </div>
                <div align="center" style="padding: 10px;">
                    <table border="0" cellpadding="0" cellspacing="0" width="600" class="wrapper">
                        <!-- LOGO/PREHEADER TEXT -->
                        <tr>
                            <td style="padding:0 0 0 5px;" class="logo">
                                <table border="0" cellpadding="0" cellspacing="0"   width="100%">
                                    <tr>
                                        <td bgcolor="#FFFFFF" style="padding:0px;" width="220" align="left">
                                            <a target="_blank" href="http://www.csu.edu.au/"><img src="http://www.csu.edu.au/__data/assets/image/0011/1353575/logo-full_bg-white.jpg" alt="Charles Sturt University" style="height: auto !important; max-width: 220px !important; width: 100% !important; border-style: none; margin: 10px; " /></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <table id="contentTable" align="center" cellspacing="0" cellpadding="0" width="100%" style="width: 100%; background: #FFF; border: 0; margin: 0 ; padding: 0;" bgcolor="#E31B23">
        <tbody>
            <tr >
                <td valign="top" height="4" style="height:4px;" bgcolor="#E31B23"></td>
            </tr>
        </tbody>
    </table>
    <!-- ONE COLUMN SECTION -->
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td bgcolor="#FAFAFA" align="center" style="padding: 0px 15px 20px 15px;" class="section-padding">
                <table border="0" cellpadding="0" cellspacing="0" width="600" class="responsive-table">
                    <tr>
                        <td bgcolor="#FFFFFF" >
                            <!-- HERO IMAGE -->
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>
                                        <!-- COPY -->
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <td align="left" style=" padding: 10px 20px 20px 20px; font-size: 15px; line-height: 24px; font-family: Helvetica, Arial, sans-serif; color: #666666;" class="padding-copy">
                                                <tr>
                                                    <td align="left" style=" padding: 10px 20px 20px 20px; font-size: 15px; line-height: 24px; font-family: Helvetica, Arial, sans-serif; color: #666666;" class="padding-copy"> 
                                                        <p>Dear <b>${requestDetails.firstName}</b>,</p>
                                                        <p>Thank you for your request. Please be advised that your request for special consideration requires <a href="http://student.csu.edu.au/services-support/student-central/faq?id=2675736">supporting documentation</a> to be considered. Once supporting documentation is obtained please upload to your <a href="${createLink(controller: "TrackRequest", action:  'index', absolute: true)}">Submitted Request</a>.</p>

                                                        <p>Please note that supporting documentation must be uploaded within 14 days of submitting your request, or your request will expire.</p>

                                                        <p>If you have any questions please contact <a href="http://student.csu.edu.au/services-support/student-central">Student Central</a>.</p>
                                                        <g:render template="/emails/emailNotificationTemplate"  />

                                                      <!--  CONTACTS SECTION --> 
                                                            <table style="background:#f1f1f1;color:#666666; text-align:left;" class="responsive-table">
                                                                <tr>
                                                                    <!--ASKCSU SEARCH WIDGET-->
                                                                    <td width="300px" valign="middle" style="padding:10px 10px 0 20px;"><img src="http://www.csu.edu.au/__data/assets/image/0003/2764218/Web-banner-sml.png" alt="AskCSU Logo" style="border-style:none; height: 200px !important; max-width:300px !important; width: 300px !important;"/></td>
                                                                    <td width="200px" valign="middle"><a href="http://student.csu.edu.au/services-support/student-central/askcsu?entry=email" target="_blank"><img src="http://www.csu.edu.au/__data/assets/image/0011/2764244/button.png"/></a></td>
                                                                </tr>
                                                            </table>
                                                        </p><!--added in-->
                                                    </td>
                                                </tr>
                                            </td>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </body>
    <footer>
        <g:render template="/emails/emailNotificationFooterTemplate"  />
    </footer>
</html>
