<%@ page import="grails.util.Environment" %>
<%@ page import="au.edu.csu.utils.AppUtils" %>
<%@ page import="au.edu.csu.specialcons.Constants" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>View Document - Special Consideration Request Form</title>
    <asset:javascript src="application/supportingdocument.js"/>
    <asset:javascript src="pdfjs/pdf.js"/>
    <asset:javascript src="pdfjs/pdf.worker.js"/>
</head>
<body>
<form id="scApplicationForm" >

	<g:set var="docid" value="${docId}"/>
	
     	<g:if test="${supportingDocuments?.size() > 0}">
        	<input type="hidden" id="filedata" value="${supportingDocuments[0].content}" />
        	<input type="hidden" id="mimeType" value="${supportingDocuments[0].mimeType}"/>
     		<g:if test="${supportingDocuments[0].mandatoryFlag == 1}">
     			<h3 class="strong text-center">Mandatory Supporting Document</h3>
     		</g:if>
     		 <g:else>
     		  	<h3 class="strong text-center">Additional Supporting Document</h3>
     		 </g:else>
     		 <div id="doc1" class="">
             		<span>
                        <g:set var="fileName" value="'${supportingDocuments[0].fileName}'"/>
                        <g:set var="mimeType" value="'${supportingDocuments[0].mimeType}'"/>
                        <g:set var="content" value="'${supportingDocuments[0].content}'"/>
                        <div id="pagination" style="display: none;">
                          <button type="button" id="prev" class="btn btn-sm btn-primary disabled">Previous</button>
						  <button type="button" id="next" class="btn btn-sm btn-primary"}>Next</button>
						  &nbsp; &nbsp;
						  <span>Page: <span id="page_num"></span> / <span id="page_count"></span></span>
						</div>
						 <br>
						 <div style="overflow: auto;">
                        	<canvas id="canvas" class="csu-canvas" ></canvas>
                        </div>
                       
             		</span>
             	</div>
             
		</g:if>
		
 </form>
</body>
</html>