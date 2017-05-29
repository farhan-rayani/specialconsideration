<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<%@ page import="au.edu.csu.specialcons.enumstudent.ExemptionReason"%>
<!doctype html>
<html>
    <head>
        <title>${emailSubject}</title>
        <style type="text/css">
            body {
                font-family: "Arial";
                font-size: 11px;
                color: #000000;
            }
        </style>
    </head>
    <body style="font-family: 'Arial';font-size: 11px; color: #000000;">
        <table style="border-collapse: collapse;">
            <tbody style="border: 1px solid black;">
                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Student Number:</span></strong></p>
                    </td>
                    <td width="386" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">${requestDetails.studentId}</span><strong></p>
                    </td>
                    
                </tr>

                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Student Name:</strong></span></p>
                    </td>
                    <td width="386" style="border: 1px solid black;">
                    <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">${requestDetails.firstName} ${requestDetails.lastName}</span><strong></p>
                    </td>
                    <td width="247">
                    </td>
                </tr>
                
                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Subject:</span></strong></p>
                    </td>
                    <td width="386" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">${subject.subject}</span><strong></p>
                    </td>
                    <td width="247">
                    </td>
                </tr>
                
                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Student Request:</span></strong></p>
                    </td>
                    <td width="386" style="border: 1px solid black;">
                        <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_EX_R}">
                            <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">Residential School Exemption</span></p>
                        </g:if>
                        <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_AW}">
                            <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">Approved Withdrawal - AW</span></p>
                        </g:if>
                         <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_GP || subject.requestTypeCode == Constants.REQUEST_TYPE_EX_C}">
                            <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">Grade Pending - GP</span></p>
                        </g:if>
                        <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_SX}">
                            <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">Supplementary Exam - SX</span></p>
                        </g:if>
                    </td>
                    <td width="247">
                    </td>
                </tr>

                <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_GP}">
                    <tr style="border: 1px solid black;">
                        <td width="188" style="border: 1px solid black;">
                            <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Estimated Extension Date:</span></strong></p>
                        </td>
                        <td width="386" style="border: 1px solid black;">
                        <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">${subject.extensionDate}</span></p>
                        </td>
                        <td width="247">
                        </td>
                    </tr>
                </g:if>
                
                <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_EX_R || subject.requestTypeCode == Constants.REQUEST_TYPE_EX_C}">
                    <tr style="border: 1px solid black;">
                        <td width="188" style="border: 1px solid black;">
                            <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Course Code:</span></strong></p>
                        </td>
                        <td width="386" style="border: 1px solid black;">
                            <g:if test="${courseDetails?.size() > 0}">
                                <g:each var="course" in="${courseDetails}">
                                    <div class="col-xs-5 pull-left">
                                        <span style="font-size:11.0pt;font-family:'Arial';color:black;">${course.programCode}</span>
                                    </div>
                                </g:each>
                            </g:if>
                        </td>
                        <td width="247">
                        </td>
                    </tr>
                </g:if>

                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Subject Coordinator Recommendation:</strong><br>(Approve/Decline)</span></p>
                    </td>
                    <td width="386" height="75" style="border: 1px solid black; background-color: #FFFF00;font-size:11.0pt;font-family:'Arial';color:black;">
                        <span style="font-size:11.0pt;font-family:'Arial';color:black;"><br><br><br><br></span>
                    </td>
                    <td width="247" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Action</strong>: Forward to Head of School or Delegate</span></p>
                    </td>
                </tr>
                 
                <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_GP}">
                    <tr style="border: 1px solid black;">
                        <td width="188" style="border: 1px solid black;">
                            <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">GP Requirements:</strong> (What outstanding work to be completed by what date).</span></p>
                        </td>
                        <td width="386" height="75" style="border: 1px solid black;background-color: #ffff80;font-size:11.0pt;font-family:'Arial';color:black;">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;"><br><br><br><br></span>
                        </td>
                        <td width="247">
                        </td>
                    </tr>
                     <tr style="border: 1px solid black;">
                        <td colspan="2" width="574" style="border: 1px solid black;text-align: center;">
                            <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_GP}">
                                <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">The School or Faculty must advise the student of GP decision &amp; details.</span></p>
                            </g:if>
                        </td>
                    </tr>
                </g:if>
               
                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Comments:</strong><br>(If declined)</span></p>
                    </td>
                    <td width="386" height="50" style="border: 1px solid black;background-color: #ffff80;font-size:11.0pt;font-family:'Arial';color:black;">
                        <span style="font-size:11.0pt;font-family:'Arial';color:black;"><br><br><br><br></span>
                    </td>
                </tr>
                <tr style="border: 1px solid black;">
                <td colspan="2" width="574" style="border: 1px solid black;text-align: center;">
                    <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">Note comments may be provided to the student.</span></p>
                </td>
                </tr>
               
                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Head of School/Delegate Decision:</strong>
                        <br>(Approve/Decline)</span></p>
                    </td>
                    <td width="386" height="100" style="border: 1px solid black;background-color: #FFFF00;font-size:11.0pt;font-family:'Arial';color:black;">
                       <span style="font-size:11.0pt;font-family:'Arial';color:black;"><br><br><br><br></span>
                    </td>
                    <td width="247" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Action</strong>: Return email to Faculty Subjects Unit
                        ask@csu.edu.au</span></p>
                    </td>
                </tr>
                <tr style="border: 1px solid black;">
                    <td colspan="2" width="574" style="border: 1px solid black;text-align: center;">
                        <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">If the Subject Coordinator&rsquo;s recommendation is declined or varied please recommend a grade (if applicable) and provide comments.</span></p>
                    </td>
                    <td rowspan="4" width="247">
                    </td>
                </tr>
                <tr style="border: 1px solid black;">
                    <td width="188" style="border: 1px solid black;">
                        <p><strong><span style="font-size:11.0pt;font-family:'Arial';color:black;">Comments:</span></strong></p>
                    </td>
                    <td width="386" height="50" style="border: 1px solid black;background-color: #ffff80;font-size:11.0pt;font-family:'Arial';color:black;">
                        <span style="font-size:11.0pt;font-family:'Arial';color:black;"><br><br><br><br></span>
                    </td>
                </tr>
                <tr style="border: 1px solid black;">
                    <td colspan="2" width="574" style="border: 1px solid black; text-align: center;">
                        <p><span style="font-size:11.0pt;font-family:'Arial';color:black;">Note comments may be provided to the student.</span></p>
                    </td>
                </tr>
                <tr style="border: 1px solid black;">
                    <td colspan="2" width="574" style="border: 1px solid black;background-color: #D3D3D3;">
                        <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_EX_R || subject.requestTypeCode == Constants.REQUEST_TYPE_EX_C}">
                                <span style="font-size:11.0pt;font-family:'Arial';color:black;"><strong>Policy: </strong>Exemption from attending compulsory residential school. Request must be submitted prior to the Residential School dates.<br><br>
                                (<a href="https://policy.csu.edu.au/document/view-current.php?id=301#section12">Assessment Policy Section 12</a> &amp; <a href="https://policy.csu.edu.au/view.current.php?id=00298#section4">Special Consideration Policy Section 4</a>) </span>
                            </g:if>
                            
                            <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_AW}">
                                    <span style="font-size:11.0pt;font-family:'Arial';color:black;">
                                    <strong>Policy: </strong>An AW after the census date can only be granted where misadventure or extenuating circumstances apply (refer to <a href="https://policy.csu.edu.au/view.current.php?id=00298#section3">Special Consideration Policy Section 3</a>); and the student was making satisfactory progress at the time the misadventure or extenuating circumstances occurred (<a href="https://policy.csu.edu.au/document/view-current.php?id=125#section13">Enrolment Policy Section 13</a>).<br><br>
                                    Declined requests to Withdraw after Census (AW) must have reasons provided and a grade awarded &ndash; <strong>FL</strong> (attempted assessments) <strong>FW</strong> (no attempted assessments).</span>
                                
                            </g:if>
                             <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_GP}">
                                <span style="font-size:11.0pt;font-family:'Arial';color:black;">
                                <strong>Policy: </strong>Extension of time to complete the subject past the last day of session.<br><br>
                                Declined requests should include comments and an alternative grade can be granted (AW/SX/FL/FW) if applicable.<br><br>
                                Please Note: Assessment is normally finalised by no later than 12 months after the end of the session in which the GP was granted.
                                (<a href="https://policy.csu.edu.au/view.current.php?id=00298#section4">Special Consideration Policy Section 4</a> &amp; <a href="https://policy.csu.edu.au/document/view-current.php?id=301#section4">Assessment Policy Section 4</a>).<br><br>
                                For the current session, a grade will not be entered until 3 weeks prior to session end to allow exam notification.</span>
                            </g:if>
                            <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_SX}">
                                <span style="font-size:11.0pt;font-family:'Arial';color:black;">
                                <strong>Policy: </strong>Student was prevented from sitting the final examination or suffered misadventure during the exam.<br><br>
                                Declined requests should include comments and an alternative grade can be granted (AW/GP/FL/FW).<br><br>
                                (<a href="https://policy.csu.edu.au/document/view-current.php?id=301#section4">Assessment Policy Section 4</a> &amp; <a href="https://policy.csu.edu.au/view.current.php?id=00298#section4">Special Consideration Policy Section 4</a>)</span>
                            </g:if>
                    </td>
                </tr>
            </tbody>
        </table>
        <br>
        <table class="nostyle">
            <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>
            <tr>
                <td style="vertical-align: text-top;align: right;">
                    <label><b><span style="font-size:11.0pt;font-family:'Arial';color:black;">Requesting</b></span></label>
                </td>
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;">${subject.subjectDisplay}:<br>${subject.requestType}</span>
                    <g:if test="${subject.requestTypeCode != 'EXR' && subject.assessmentItem != 'COMPLETED' 
                            && subject.assessmentItem != 'PASSED' && subject.assessmentItem != 'CANT_COMPLETE'}">
                        <g:if test="${subject.assessmentItem}">
                             <br><span style="font-size:11.0pt;font-family:'Arial';color:black;">"${subject.assessmentItem}"</span>
                        </g:if>
                        <g:if test="${subject.extensionDate}">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;"> by ${subject.extensionDate}</span>
                        </g:if>
                    </g:if>
                    <g:else>
                        <g:if test="${subject.assessmentItem == 'PASSED'}">
                            <br><span style="font-size:11.0pt;font-family:'Arial';color:black;">"${ExemptionReason.PASSED}"</span>              
                        </g:if>
                        <g:elseif test="${subject.assessmentItem == 'COMPLETED'}">
                            <br><span style="font-size:11.0pt;font-family:'Arial';color:black;">"${ExemptionReason.COMPLETED}"</span>
                        </g:elseif>
                        <g:elseif test="${subject.assessmentItem == 'CANT_COMPLETE'}">
                            <br><span style="font-size:11.0pt;font-family:'Arial';color:black;">"${ExemptionReason.CANT_COMPLETE}"</span>
                        </g:elseif>
                    </g:else>
                </td>
            </tr>
            <tr><br></tr>
            <g:if test="${subject.assessmentItem != 'PASSED'}">
                <tr>
                    <td align="right" width="300px">
                        <g:if test="${subject.assessmentItem != 'COMPLETED'}">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Main reason for request</b></label></span>
                        </g:if>
                        <g:else>
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Details of exemption</b></label></span>
                        </g:else>
                    </td>
                    <td style="padding:0 25px 0 25px;">
                       <g:if test="${subject.reason != 'Unknown reason'}">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;">${subject.reason} - ${subject.reasonText}</span>
                       </g:if>
                       <g:else>
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;">${subject.reasonText}</span>
                       </g:else>
                    </td>
                </tr>
            </g:if>
            <tr><br></tr>
            <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_EX_R && subject.assessmentItem != 'PASSED'}">
                <tr>
                    <g:if test="${supportingDocuments?.size() == 0}">
                        <td align="right">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Supporting documents</b></label></span>
                        </td>
                        <td style="padding:0 25px 0 25px;">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;">None provided</span>
                        </td>
                    </g:if> 
                </tr>
            </g:if>
            <g:if test="${subject.requestTypeCode == Constants.REQUEST_TYPE_GP ||  
                subject.requestTypeCode == Constants.REQUEST_TYPE_SX || subject.requestTypeCode == Constants.REQUEST_TYPE_AW || subject.requestTypeCode == Constants.REQUEST_TYPE_EX_C ||
                (subject.requestTypeCode == Constants.REQUEST_TYPE_EX_R && subject.assessmentItem == 'CANT_COMPLETE')}">
                    <tr>
                        <g:if test="${supportingDocuments?.size() > 0}">
                            <g:if test="${supportingDocuments[0].requestid == 0}">
                                <td align="right">
                                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Supporting documents</b></label></span>
                                </td>
                                <g:if test="${supportingDocuments[0].requestid == 0}">
                                    <td style="padding:0 25px 0 25px;">
                                        <span style="font-size:11.0pt;font-family:'Arial';color:black;">${supportingDocuments[0].fileName}</span>
                                    </td>
                                </g:if>
                            </g:if>
                        </g:if> 
                    </tr>
                    <tr><br></tr>
                         <g:if test="${supportingDocuments?.size() > 1}">
                            <g:if test="${supportingDocuments[1].requestid == 0}">
                                <tr>
                                    <td></td>
                                    <td style="padding:0 25px 0 25px;">
                                        <span style="font-size:11.0pt;font-family:'Arial';color:black;">${supportingDocuments[1].fileName}</span>
                                    </td>
                                </tr>
                                <tr><br></tr>
                            </g:if>
                        </g:if> 

                         <g:if test="${supportingDocuments?.size() > 2}">
                            <g:if test="${supportingDocuments[2].requestid == 0}">
                               <tr>
                                    <td></td>
                                    <td style="padding:0 25px 0 25px;">
                                        <span style="font-size:11.0pt;font-family:'Arial';color:black;">${supportingDocuments[2].fileName}</span>
                                    </td>
                                </tr>
                                <tr><br></tr>
                            </g:if>
                        </g:if> 
            </g:if>
            <g:elseif test="${subject.requestTypeCode == Constants.REQUEST_TYPE_EX_R && subject.assessmentItem == 'COMPLETED'}">
                <tr>
                    <td align="right">
                        <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Supporting documents</b></label></span>
                    </td>
                     <g:each var="doc" in="${supportingDocuments}">
                        <g:if test="${doc.requestid > 0}">
                            <td style="padding:0 25px 0 25px;">
                                <span style="font-size:11.0pt;font-family:'Arial';color:black;">${doc.fileName}</span>
                            </td>     
                        </g:if>
                    </g:each>
                </tr>
            </g:elseif>

           <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>
            <tr>
                <td align="right">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Given name</b></label></span>
                </td>
                 <td style="padding:0 25px 0 25px;">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;">${requestDetails.firstName}</span>
                 </td>
            </tr>
            <tr><br></tr>
            <tr>
                <td align="right">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Family name</b></label></span>
                </td>
                 <td style="padding:0 25px 0 25px;">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;">${requestDetails.lastName}</span>
                 </td>
            </tr>
            <tr><br></tr>
            <tr>
                <td align="right">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Email address</b></label></span>
                </td>
                 <td style="padding:0 25px 0 25px;">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;">${requestDetails.emailAddress}</span>
                </td>
            </tr>
            <tr><br></tr>
            <tr>
                <td align="right">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Student ID number</b></label></span>
                </td>
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;">${requestDetails.studentId}</span>
                </td>
            </tr>
            <tr><br></tr>
            <tr>
                <td align="right">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Full course name</b></label></span>
                </td>
                <g:if test="${courseDetails?.size() > 0}">
                    <g:each var="course" in="${courseDetails}">
                        <td style="padding:0 25px 0 25px;">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;">${course.programName}</span>
                        </td>
                        <tr><td></td></tr>
                    </g:each>
                </g:if> 
            </tr>
            <tr><br></tr>
            <tr>
                <td align="right">
                    <span style="font-size:11.0pt;font-family:'Arial';color:black;"><label><b>Course code</b></label></span>
                </td>
                <g:if test="${courseDetails?.size() > 0}">
                    <g:each var="course" in="${courseDetails}">
                        <td style="padding:0 25px 0 25px;">
                            <span style="font-size:11.0pt;font-family:'Arial';color:black;">${course.programCode}</span>
                        </td>
                        <tr><td></td></tr>
                    </g:each>
                </g:if>
            </tr>
            <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>
        </table>
    </body>
    
</html>