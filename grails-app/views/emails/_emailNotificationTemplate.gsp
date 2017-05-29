<%@ page import="au.edu.csu.specialcons.enumstudent.ExemptionReason"%>
<table style="table-layout: fixed; cellpadding: 0px; cellspacing: 0px; line-height: 20px; line-width: 700px;">
    <g:set var="title" value='0'/>
    <!-- For ALL request types OTHER than RESI school exemption requests -->
    <g:if test="${Integer.valueOf(otherSCRequestsFlag) == 1}">
        <tr><td colspan="2" style="border-top: 1px solid #8c8b8b; "></td></tr>
        <g:each var="subject" in="${subjectList}" status="index">
                <g:if test="${subject.assessmentItem != 'COMPLETED' && subject.assessmentItem != 'PASSED'}">
                    <tr>
                        <g:if test="${title == '0'}">
                            <td width="300" style="vertical-align: top;text-align: right;word-break: break-all;">
                                <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Requesting</b></span>
                            </td>
                            <g:set var="title" value='1'/>
                        </g:if>
                        <g:else>
                            <td align="right"></td>
                        </g:else>
                        <td width="450" style="padding:0 25px 0 25px;text-align: left;">
                            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">
                                ${subject.subjectDisplay}:<br>${subject.requestType}<br>
                                <g:if test="${subject.assessmentItem != null}">
                                    ${subject.assessmentItem != 'CANT_COMPLETE' ? '"'+subject.assessmentItem+'"' : '"'+ExemptionReason.CANT_COMPLETE+'"'} 
                                </g:if>
                                    ${subject.extensionDate != null ? 'by '+subject.extensionDate : ''}
                            </span>                        
                        </td>
                    </tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                </g:if>
        </g:each>
        
        <tr>
            <td style="vertical-align: top;text-align: right;word-break: break-all;">
                <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Main reason for request</b></span>
            </td>
            <g:if test="${subjectList[0].assessmentItem != 'COMPLETED' && subjectList[0].assessmentItem != 'PASSED'}">
                <td style="padding:0 25px 0 25px;">
                   <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${subjectList[0].reason} - ${subjectList[0].reasonText}</span>
                </td>
            </g:if>
        </tr>
        <tr><td colspan="2">&nbsp;</td></tr>
        <tr>
            <g:if test="${supportingDocuments?.size() == 0}">
                <td align="right">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Supporting documents</b></span>
                </td>
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">None provided</span>
                </td>
            </g:if> 
        </tr>
        <tr>
            <g:if test="${supportingDocuments?.size() > 0 && supportingDocuments[0].requestid==0}">
                <td align="right">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Supporting documents</b></span>
                </td>
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${supportingDocuments[0].fileName}</span>
                </td>
            </g:if> 
        </tr>
        
             <g:if test="${supportingDocuments?.size() > 1 && supportingDocuments[1].requestid==0}">
                <tr>
                    <td></td>
                    <td style="padding:0 25px 0 25px;">
                        <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${supportingDocuments[1].fileName}</span>
                    </td>
                </tr>
                <tr><br></tr>
            </g:if> 

             <g:if test="${supportingDocuments?.size() > 2 && supportingDocuments[2].requestid==0}">
               <tr>
                    <td></td>
                    <td style="padding:0 25px 0 25px;">
                        <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${supportingDocuments[2].fileName}</span>
                    </td>
                </tr>
            </g:if> 
            <tr><td colspan="2">&nbsp;</td></tr>
    </g:if>
    <g:set var="title" value='0'/>
    <!-- For Resi school exemption with previously PASSED subject -->
    <g:if test="${Integer.valueOf(resiSchoolExemptionPassedFlag) == 1}">
        <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>
        <g:each var="subject" in="${subjectList}" status="index">
                <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'PASSED'}">
                    <tr>
                        <g:if test="${title == '0'}">
                            <td align="right" style="vertical-align: top;">
                                <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Requesting</b></span>
                            </td>
                            <g:set var="title" value='1'/>
                        </g:if>
                         <g:else>
                            <td align="right"></td>
                        </g:else>
                        <td style="padding:0 25px 0 25px;">
                            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${subject.subjectDisplay}:<br>${subject.requestType}<br>"${ExemptionReason.PASSED}"</span>
                        </td>
                    </tr>
                </g:if>
        </g:each>
        <tr><td colspan="2">&nbsp;</td></tr>
    </g:if>
    <g:set var="title" value='0'/>
    <!-- For Resi school exemption with previously COMPLETED subject -->
    <g:if test="${Integer.valueOf(resiSchoolExemptionCompletedFlag) == 1 }">
        <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>
        <g:each var="subject" in="${subjectList}" status="index">
            <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'COMPLETED'}">
                <tr>
                    <g:if test="${title == '0'}">
                        <td align="right" style="vertical-align: top;">
                            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Requesting</b></span>
                        </td>
                        <g:set var="title" value='1'/>
                    </g:if>
                    <g:else>
                        <td align="right"></td>
                    </g:else>
                    <td style="padding:0 25px 0 25px;">
                        <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${subject.subjectDisplay}:<br>${subject.requestType}<br>"${ExemptionReason.COMPLETED}"</span><br>
                    </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                    <td align="right" style="vertical-align: top;">
                        <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Details of exemption</b></span>
                    </td>
                    <td style="padding:0 25px 0 25px;">
                            <span style="width:75%; word-wrap:break-word; display:inline-block;font-size: 10pt;font-family: Helvetica;color: #606060;">${subject.reasonText}</span>
                    </td>
                </tr>
            </g:if>
        </g:each>
        <!--
        <tr><td colspan="2">&nbsp;</td></tr>
        <tr>
           <g:if test="${subjectList?.size() > 0}">
                    <g:if test="${title == '0'}">
                        <td align="right">
                            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Details of exemption</b></span>
                        </td>
                        <g:set var="title" value='1'/>
                    </g:if>
                    <g:else>
                        <td align="right"></td>
                    </g:else>            
                <g:each var="subject" in="${subjectList}">
                    <g:if test="${subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'COMPLETED'}">
                        <td style="padding:0 25px 0 25px;">
                            <span style="width:75%; word-wrap:break-word; display:inline-block;font-size: 10pt;font-family: Helvetica;color: #606060;">${subject.reasonText}</span>
                        </td>
                     </g:if>
                </g:each>
            </g:if>
        </tr>
        -->
        <tr><td colspan="2">&nbsp;</td></tr>     
        <tr>
            <td align="right" style="vertical-align: top;">
                <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Supporting documents</b></span>
            </td>
            <g:set var="docProvidedSupSchool" value="${0}"/>
            <g:each var="supportingDocument" in="${supportingDocuments}">
                <g:if test="${supportingDocument.requestid>0}">
                    <g:set var="docProvidedSupSchool" value="${1}"/>
                    <td style="padding:0 25px 0 25px;">
                        <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${supportingDocument.fileName}</span>
                    </td>
                </g:if>
            </g:each>
            <g:if test="${docProvidedSupSchool==0}">
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">None provided</span>
                </td>
            </g:if>
        </tr>
        <tr><td colspan="2">&nbsp;</td></tr>
    </g:if>

   <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>
    <tr>
        <td align="right">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Given name</b></span>
        </td>
         <td style="padding:0 25px 0 25px;">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${requestDetails.firstName}</span>
         </td>
    </tr>
    
    <tr>
        <td align="right">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Family name</b></span>
        </td>
         <td style="padding:0 25px 0 25px;">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${requestDetails.lastName}</span>
         </td>
    </tr>
    
    <tr>
        <td align="right">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Email address</b></span>
        </td>
         <td style="padding:0 25px 0 25px;">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${requestDetails.emailAddress}</span>
        </td>
    </tr>
    
    <tr>
        <td align="right">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Student ID number</b></span>
        </td>
        <td style="padding:0 25px 0 25px;">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${requestDetails.studentId}</span>
        </td>
    </tr>
    
    <tr>
        <td align="right">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Full course name</b></span>
        </td>
        <g:if test="${courseDetails?.size() > 0}">
            <g:each var="course" in="${courseDetails}">
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${course.programName}<br></span>
                </td>                
            </g:each>
        </g:if> 
    </tr>
    
    <tr>
        <td align="right">
            <span style="font-size: 10pt;font-family: Helvetica;color: #606060;"><b>Course code</b></span>
        </td>
        <g:if test="${courseDetails?.size() > 0}">
            <g:each var="course" in="${courseDetails}">
                <td style="padding:0 25px 0 25px;">
                    <span style="font-size: 10pt;font-family: Helvetica;color: #606060;">${course.programCode}<br></span>
                </td>
            </g:each>
        </g:if>
    </tr>
    <tr><td colspan="2" style="border-top: 1px solid #8c8b8b;"></td></tr>

</table>

<br>
<span style="font-size: 11.5pt; font-family: Helvetica; color:#606060;"><p>Student Administration<br>
Charles Sturt University</p></span>
