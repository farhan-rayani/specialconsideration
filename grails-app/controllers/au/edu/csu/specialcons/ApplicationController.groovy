package au.edu.csu.specialcons

import grails.converters.JSON
import grails.core.GrailsApplication
import groovy.util.logging.Slf4j
import au.edu.csu.specialcons.enumstudent.ExemptionReason
import au.edu.csu.specialcons.exceptions.ApplicationException
import au.edu.csu.specialcons.security.SecurityService
import au.edu.csu.utils.AppUtils
import au.edu.csu.utils.DateUtils
import au.edu.csu.utils.StringUtils
import org.springframework.web.multipart.support.StandardMultipartHttpServletRequest


/**
 * Controller for the Special Consideration application form.
 * 
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		17-OCT-2016
 */
@Slf4j
class ApplicationController {
	
	EnterpriseDataService enterpriseDataService
	RestService restService
	SecurityService securityService
	def mailService
	GrailsApplication grailsApplication
	
	//To set the session data
	def setSessionData()
	{
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		log.debug("params.key: ${params.key}")
		if (params.key == "POST_END_OF_SESSION_REMINDER_FLAG")
		{
			if(params.flag == 'on') 
				session[params.key] = true
			else
			    session[params.key] = false
		}
		if (params.key == "END_OF_TERM_REMINDER_FLAG")
		{
			if(params.flag == 'on') 
				session[params.key] = true
			else
			    session[params.key] = false
		}
		render ""
	}

	//To get the session data
	def getSessionData()
	{
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		log.debug("params.key: ${params.key}")
		response.setContentType("application/json")
		String value = session["${params.key}"] as String
		String retVal = '{"result":"'+ value + '"}'
		log.debug("Session Data : ${retVal}")
		render contentType: "text/json", text: retVal
	}

	/**
     * Logout action
     */
    def logout() { 
    	log.debug("Controller: ${controllerName}, Action: ${actionName}") 
    	// session.invalidate() does not work in tomcat 7.0.54 in a clustered environment
		// as a temporary solution, all session attributes that have been set must be removed
		// reference: https://bz.apache.org/bugzilla/show_bug.cgi?id=56578
    	session.POST_END_OF_SESSION_REMINDER_FLAG = null
		session.END_OF_TERM_REMINDER_FLAG = null
    	session.invalidate()
		redirect(url: grailsApplication.config.logoutURL)
    }

    /**
     * Default action for this controller. Renders the start view for the application process.
     */
    def index() { 
		log.debug("Controller: ${controllerName}, Action: ${actionName}") 
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		
		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		def subjectList = enterpriseDataService.getEligibleSubjects(userDetails.pidm)
		def requestList = Request.findAllByGuid('')
		//requestList.each { request ->
		//log.debug(" ID : " + requestList)
		//log.debug(" subjects : " + subjectList)
		//}
		log.debug(" subjects : " + subjectList)
		render(view: 'subjectSelection', model: [subjectList: subjectList, requestList: requestList, mode: "create", newRequest: "true", headerText: "Request for Special Consideration"])
	}
	
	/**
	 * Reason action for this controller. Renders the Reason view for the application process.
	 */
	def reason() {
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		
		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		
		if (!params.guid) {
			redirect(uri: AppUtils.getBaseUrl())
		}
		
		log.debug("GUID: ${params.guid}")
		def showSubjects = false
		def showStep2b = false
		def result = getApplicationDetails(params.guid)
		def subjectList = result.subjectList
		def excludeSubj = subjectList.find { subject -> (subject.requestTypeCode?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("PASSED")) }
		
		if(excludeSubj){
			subjectList.remove(excludeSubj)
			showSubjects = true
		}
		if(subjectList.size() == 0){
			redirect(action: "review", params: [guid: params.guid,skipStep2:"true"])
			return true
		}
		excludeSubj = subjectList.find { subject -> (subject.requestTypeCode?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("COMPLETED")) }
		if(excludeSubj){
			subjectList.remove(excludeSubj)
			showSubjects = true
			showStep2b= true 
		}
		
		if(subjectList.size() == 0){
			redirect(action: "reasonResSchoolExemption", params: [guid: params.guid,skipStep2a:"true"])
			return true
		}
		
		render(view: 'reason', model: [guid: params.guid, mode: "create", newRequest: "true", headerText: "Request for Special Consideration",
			   ciVisible:grailsApplication.config.criticalIncident.visible,incident:grailsApplication.config.criticalIncident.incident,
			   "subjectList":subjectList,"showSubjects":showSubjects,"showStep2b":showStep2b])
	}

	/**
	 * Reason for residential school exemption requests action for this controller. Renders the reasonResSchoolExemption view for the application process.
	 */
	def reasonResSchoolExemption(){
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		def guid = params.guid
		def resExemptDocId = 0
		def subjectList = []
		def supportingDocuments =[]
		def supportingDoc = []
		def mode = "create"
				
			if (!userDetails) {
				throw new ApplicationException("Unable to determine user from login ID ${user}.")
			}
			
			if (!params.guid) {
				redirect(uri: AppUtils.getBaseUrl())
			}
			
			log.debug("GUID: ${params.guid}") 
			def result = getApplicationDetails(guid)
			
			def subjects = result.subjectList
			def supportingDocumentList = result.supportingDocuments
			subjectList.add(subjects.find{subject -> (subject.requestTypeCode == 'EXR' && subject.assessmentItem == 'COMPLETED')})
			
			if (subjectList?.size()>0) {
				mode="edit"
			}
			supportingDoc = supportingDocumentList.find {supportDoc -> supportDoc.requestid > 0}
			
			if(supportingDoc)
			{
				supportingDocuments.add(supportingDoc)
			}
			
		
		render(view: 'reasonResSchoolExemption', model: [guid: params.guid, subjectList: subjectList, documentList: supportingDocuments, 
			mode: mode, newRequest: "true", headerText: "Request for Special Consideration",fragment: params.fragment])
	}

	/**
	 * Review action for this controller. Renders the Review view for the application process.
	 */
	def review() {
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		def guid = params.guid
		/*def subjectList = []
		def requestDetails = [:]
		def supportingDocuments = []
		
		def currentTerms = enterpriseDataService.getCurrentTerms()
		def courseDetails = enterpriseDataService.getCourseDetails(userDetails.pidm, currentTerms.termCode) 
		*/

		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		
		if (!params.guid) {
			redirect(uri: AppUtils.getBaseUrl())
		}
		
		log.debug("GUID: ${params.guid}")
		def result = getApplicationDetails(guid)
		
		render(view: 'review', model: [guid: params.guid, userDetails: result.userDetails, 
				subjectList: result.subjectList, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
				courseDetails: result.courseDetails, otherSCRequestsFlag: result.otherSCRequestsFlag, 
				resiSchoolExemptionPassedFlag: result.resiSchoolExemptionPassedFlag, 
				resiSchoolExemptionCompletedFlag: result.resiSchoolExemptionCompletedFlag, 
				mode: params.mode, newRequest: params.newRequest, headerText: "Request for Special Consideration"])
		
	}

	def showdocument()
	{
		def supportingDocuments = []
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		log.debug("params : " + params.guid + " DocId : " + params.docId)
		if (!params.guid || !params.docId) {
			redirect(uri: AppUtils.getBaseUrl())
		}
		def supportingDocumentList = SupportingDocument.findAllByGuidAndDocid(params.guid, params.docId)
		
				if(supportingDocumentList)
					{
						supportingDocumentList.each { doc -> 
							supportingDocuments.add([fileName: doc.fileName, content: Base64.getEncoder().encodeToString(doc.document), mimeType: doc.mimeType, mandatoryFlag: doc.mandatory])
						}

					}

		//render "Supporting Document"
		render(view: 'supportingdocument', model: [supportingDocuments: supportingDocuments, docId: params.docId, headerText: "View Document"])
		
	}

	/**
	 * Complete action for this controller. Renders the Complete view for the application process.
	 */
	def complete() {
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		log.debug("Params from Complete : ${params}")
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		
		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		
		if (!params.guid) {
			redirect(uri: AppUtils.getBaseUrl())
		}
		
		log.debug("GUID: ${params.guid}")
		sendConfirmationEmailAppsWithSupportingDocs(params.guid)
		sendDSOEmail(params.guid)
		render(view: 'complete', model: [guid: params.guid, email: userDetails.emailAddress, headerText: "Request for Special Consideration"])
	}

	/**
	 * edit subject selection
	 */
	def editSubjects() {
		
		log.debug("Controller: ${controllerName}, Action: ${actionName}, params: ${params}") 
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		def resiSchoolExemptionCompletedFlag = 0

		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		def subjectList = enterpriseDataService.getEligibleSubjects(userDetails.pidm)
		
		def requestList = Request.findAllByGuid(params.guid)
		
		if(requestList.find { subject -> (subject.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("COMPLETED")) })
		resiSchoolExemptionCompletedFlag=1
		
		render(view: 'subjectSelection', model: [
			guid: params.guid, 
			subjectList: subjectList,
			requestList: requestList, 
			resiSchoolExemptionCompletedFlag: resiSchoolExemptionCompletedFlag,
			mode: "edit", newRequest: params.newRequest, headerText: "Request for Special Consideration"])
	}

	/**
	 * edit Reason
	 */
	def editReason() {
		
		log.debug("Controller: ${controllerName}, Action: ${actionName}, params: ${params}") 
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		
		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		
		
		def requestList = Request.findAllByGuid(params.guid)
		def resiExemptRequest =[]
		def query = SupportingDocument.where{ guid == params.guid && requestid == 0}
		def documentList = query.list()
		def showSubjects = false
		def showStep2b = false
		def result = getApplicationDetails(params.guid)
		def subjectList = result.subjectList
		def excludeSubj = subjectList.find {subject -> (subject.requestTypeCode?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("PASSED")) }
		if(excludeSubj){
			subjectList.remove(excludeSubj)
			showSubjects = true
		}
		if(subjectList.size() == 0){
			redirect(action: "review", params: [guid: params.guid,skipStep2:"true"])
			return true
		}
		excludeSubj = subjectList.find { subject -> (subject.requestTypeCode?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("COMPLETED")) }
		if(excludeSubj){
			subjectList.remove(excludeSubj)
			showSubjects = true
			showStep2b = true 
		}

		if(subjectList.size() == 0){
			redirect(action: "reasonResSchoolExemption", params: [guid: params.guid,skipStep2a:"true"])
			return true
		}

		resiExemptRequest = requestList.find { request -> (request.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && request.assessmentItem?.equals("PASSED")) ||
		(request.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && request.assessmentItem?.equals("COMPLETED"))}
		if(resiExemptRequest){
			requestList.remove(resiExemptRequest)
		}
		
		render(view: 'reason', model: [
			guid: params.guid, 
			documentList: documentList,
			requestList: requestList, 
			mode: "edit", newRequest: params.newRequest, headerText: "Request for Special Consideration", fragment: params.fragment,
			ciVisible:grailsApplication.config.criticalIncident.visible,incident:grailsApplication.config.criticalIncident.incident,
			"subjectList":subjectList,"showSubjects":showSubjects,"showStep2b":showStep2b])
	}

	/**
	 * Delete Method
	 */
	def delete() {
		log.debug("Controller : ${controllerName}, Action : ${actionName}")

		//delete SC application and all associated supporting documents
		deleteApplication(params)
		redirect(uri:'/')
	}

	/**
	 * cancel Method to cancel all requests for the supplied GUID
	 */
	def cancel() {
		log.debug("Controller : ${controllerName}, Action : ${actionName}")

		 
		def requestid = params.requestid
		log.debug("GUID and Request ID to CANCEL Application: ${params.guid} ${requestid}")
		def specialConRequestList = []
		//cancel request the selected request
		specialConRequestList = Request.findAllById(requestid)
		
		try {
			specialConRequestList.each{ specialConRequest ->
			specialConRequest.statusId = RequestStatus.get(Constants.STATUS_CANCELLED)
			specialConRequest.statusDate = DateUtils.sysdate() 
			specialConRequest.activityDate = DateUtils.sysdate()
			specialConRequest.save(flush: true, failOnError: true)
		}
		}
		catch(Exception e) {
			log.debug(e.getMessage())
		}

	}

	/**
	 * Save Method
	 */
	def save() {
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		def returnData = [:]
		def errors = []
		def guid = null
		
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		Person person = enterpriseDataService.getPersonForUsername(user)
		
		if (!person) {
			//throw new ApplicationException("Missing required parameter from request: person")
			errors.add("Unable to determine the logged-in user.")
		}
		params.person = person

		
		log.debug("Params from Save: ${params}")
		
		// Determine stage that user is saving from.
		if (params.saveStep) {
			switch(params.saveStep) {
				case "SUBJECT":
					// Subject & type save
					if (params.mode == "create") 
					{

						guid = createNewApplication(params)
					}
					else
						guid = updateApplications(params)
					
					if (guid) {
						returnData = [success: 'true', guid: guid]
					}
					break;
					
				case "REASON":
					// Reason/upload save
					guid = saveReason(params)
					returnData = [success: 'true', guid: guid]
					break;

				case "EXEMPTION_RES_SCHOOL_REASON":
					// Save Reason for exemption from residential school
					guid = saveReasonForResSchoolExemption(params)
					returnData = [success: 'true', guid: guid]
					break;

				case "REVIEW":
					// submit
					guid = submitApplication(params)
					returnData = [success: 'true', guid: guid]
					break;

				case "UPDATE_REVIEW":
					// Upload documents
					guid = uploadDocuments(params)
					returnData = [success: 'true', guid: guid]
					break;	
				default:
					// Invalid saveStep parameter?
					break;
			}
		} else {
			//throw new ApplicationException("Missing required parameter from request: saveStep")
			errors.add("Missing required parameter from request: saveStep")
		}
		
		if (errors.size() > 0) returnData.errors = errors
		render returnData as JSON
	}
	
	/**
	 * @param params
	 * @return
	 */
	private def createNewApplication(Map params) {
		
		def requestList = []
		def guid = StringUtils.generateUUID()
		log.debug("New GUID: ${guid}")
		
		// Determine how many subjects are in the application
		def subjectCount = params.count { key, value -> ((String) key)?.contains("subject") }
		log.debug("Found ${subjectCount} requests in parameters map.")
		
		def subjectList = params.findAll { key, value -> 
			((String) key)?.contains("subject")
		}
		
		log.debug("Subject List: ${subjectList}")
		
		// Create a request for each
		//for (int i = 0; i < subjectCount; i++) {
		subjectList.each { key, value ->
			def i = key.find( /\d+/ )
			log.debug("index = ${i}")
			
			def subject = params."subject${i}"
			def requestType = params."requestType${i}"
			def assessment = params."assessment${i}" ? params."assessment${i}" : params."selDetail${i}"
			def extensionDate = DateUtils.parseDate(params."extensionDate${i}", "dd/MM/yyyy")
			
			log.debug("subject: ${subject}")
			def subjectOffering = subject.split("_") //subject is in format of 'crn_termCode'
			if (StringUtils.isEmpty(subjectOffering[0])) {
				throw new ApplicationException("Missing required parameter: crn")
			}
			if (StringUtils.isEmpty(subjectOffering[1])) {
				throw new ApplicationException("Missing required parameter: termCode")
			}
			
			Request subjectRequest = new Request(guid: guid, 
				pidm: params.person.pidm,
				statusId: RequestStatus.get(Constants.STATUS_NOT_SUBMITTED),
				requestType: requestType,
				crn: subjectOffering[0],
				session: subjectOffering[1],
				assessmentItem: assessment,
				extensionDate: extensionDate,
				hasOptionalDocumentation: 0,
				counselling: 0, 
				hasProvidedDocumentation: 0,
				hasSubmitted: Constants.STATUS_NOT_SUBMITTED, 
				activityDate: DateUtils.sysdate(), 
				createdDate: DateUtils.sysdate())
			
			log.debug("Request: ${subjectRequest}")
			log.debug("******************** Transaction START : " + DateUtils.sysdate())
			subjectRequest.save(flush: true, failOnError: true)
			log.debug("******************** Transaction END : " + DateUtils.sysdate())
			//requestList.add(subjectRequest)
		}
		
		// Save & return guid. 
		return guid
	}

	/**
	 * Action when user clicks on the subject link or status button on student facing request tracking page
	 * @param params
	 * @return
	 */
	def updateReveiwRequest()
	{	
		log.debug("Controller: ${controllerName}, Action: ${actionName}")
		log.debug("params for updateReveiwRequest : ${params}")

		def guid = params.guid
		def mode = params.mode
		def requestID = params.requestId
		def headerText = ""
		def supportingDocuments = []
		def supportingDoc = []
		def request = []
		def requestDate = null
		def statusDate = null
		def query = ''
		headerText = (mode == 'edit'? "Review Request - Upload Document" : "Review Request")
		
		def result = getApplicationDetails(guid)
		def supportingDocumentList = result.supportingDocuments
		def requestDetails = result.requestDetails
		query = Request.where{ guid == guid && id == requestID}
		request = query.list()
		
		if (request) {
			if (request[0].requestType == Constants.REQUEST_TYPE_EX_R) {
				supportingDoc = supportingDocumentList.find {supportDoc -> 
					supportDoc.requestid == Integer.parseInt(requestID)}
			}
			else
			{
				supportingDoc = supportingDocumentList.find {supportDoc -> supportDoc.requestid == 0}
			}

			requestDetails.status = request[0].statusId.getTitle()
			requestDetails.statusCode = request[0].statusId.getId()
			if (request[0].requestDate != null) 
			requestDetails.requestDate = DateUtils.formatDate(new Date(request[0].requestDate.getTime()), "dd/MM/yyyy")
			if (request[0].statusDate != null) 
			requestDetails.statusDate = DateUtils.formatDate(new Date(request[0].statusDate.getTime()), "dd/MM/yyyy")	
		}
			if(supportingDoc)
			{
				supportingDocuments.add(supportingDoc)
			}

		render(view: 'updateReveiwRequest', model: [guid: params.guid, requestId: params.requestId,  
				subjectList: result.subjectList, requestDetails: requestDetails, supportingDocuments: supportingDocuments, courseDetails: result.courseDetails, mode: params.mode, headerText: headerText, mandatorySupportingDocsSubmitted: result.mandatorySupportingDocsSubmitted])

	} 

	/**
	 * @param params
	 * @return
	 */
	private def updateApplications(Map params) {
		def specialConRequestList = Request.findAllByGuid(params.guid)
		def requestIds = new int[specialConRequestList.size()]
		def guid = params.guid
		// Determine how many subjects are in the application
		def subjectCount = params.count { key, value -> ((String) key)?.contains("subject") }
		def subjectList = params.findAll { key, value -> 
			((String) key)?.contains("subject")
		}
		def suppliedIds = new int[subjectList.size()]
		//log.debug("Subject List: ${subjectList}")
		//populate an array of currently save ids from the DB
		specialConRequestList.eachWithIndex { request, index ->
			requestIds[index] = request.id
		}

		//popultae an array oof ids from the incoming request params
		log.info("populate arrays ${subjectList}")
		def cntr = 0
		subjectList.each { key, value ->
			def i = key.find( /\d+/ )
			def id = params."id${i}"
			suppliedIds[cntr] = id.toInteger()
			cntr++
		}
		Set<Integer> s1 = new HashSet<Integer>(Arrays.asList(requestIds))
		Set<Integer> s2 = new HashSet<Integer>(Arrays.asList(suppliedIds))
		s1.removeAll(s2)
		def Integer[] deleteRecords = s1.toArray(new Integer[s1.size()])
		
		//loop through the array of deleteRecords to remove those requests which were deleted by the student
		deleteRecords.eachWithIndex  {val, i -> 
			//log.debug("Delete : " + deleteRecords[i])
			//search for the record which has already been saved earlier for the id 
			Request subjectRequest = Request.findById(deleteRecords[i])
			if (subjectRequest) {
				subjectRequest.delete(flush: true, failOnError: true)
				if(subjectRequest.id>0)
				deleteSupportingDocument(guid, subjectRequest.id.toInteger())
				log.debug("Deleted : " + deleteRecords[i])
			}
		}

		//loop through all current apps\requests for the GUID and update those which exist in the params and insert any new ones
		specialConRequestList.each { request ->
			subjectList.each { key, value ->
				//log.debug(" Key = " + key)
				def i = key.find( /\d+/ )
				//log.debug("index = ${i}")
				//log.debug("++ Subject: " + params."subject${i}")
				def id = params."id${i}"
				def subject = params."subject${i}"
				def requestType = params."requestType${i}"
				def assessment 

				if(requestType != Constants.REQUEST_TYPE_EX_R){
					assessment = params."assessment${i}"
				}
				else{
					assessment = params."selDetail${i}"
				}
				
				def extensionDate = DateUtils.parseDate(params."extensionDate${i}", "dd/MM/yyyy")
				def subjectOffering = subject.split("_")
				//log.debug(" id = " + id + " i = " + i)
				if (request.id == id.toInteger()) {
					//log.debug("+++ Request ID = *"+ request.id + "* params.id = *" + id + "*")
					//search for the record which has already been saved earlier for the id 
					Request subjectRequest = Request.findById(request.id)
					
					//check if anything has changed, only update if there are changes
					//if (subjectRequest.crn != subjectOffering[0] || subjectRequest.requestType != requestType ||
					//	(requestType == Constants.REQUEST_TYPE_GP && (DateUtils.formatDate(subjectRequest.extensionDate, 'dd/MM/yyyy') != params."extensionDate${i}" ||
					//	subjectRequest.assessmentItem != assessment))) {
						//update subject details if user decided to choose a different subject
					
						subjectRequest.crn = subjectOffering[0]
						subjectRequest.session = subjectOffering[1]
						
						
						//if previous request type was for Exemption from Resi school for the work completed, 
						//find any optional supporting documents and delete them
						if((requestType != Constants.REQUEST_TYPE_EX_R && assessment != 'COMPLETED') && 
						   (subjectRequest.requestType == Constants.REQUEST_TYPE_EX_R || subjectRequest.assessmentItem == 'COMPLETED')) {
							def query = SupportingDocument.where{guid == guid && requestid == subjectRequest.id}
							def supportingDocumentList = query.list()
							
							if(supportingDocumentList)
								{
									supportingDocumentList.each { doc -> 
										doc.delete(flush: true, failOnError: true)
									}

								}
						}
						//if request has been changed to resi school exemption (for COMPLETED or PASSED) from any other type of request e.g. GP, SX, AW etc
						//clear corresponding Reason text
						if(subjectRequest.requestType != Constants.REQUEST_TYPE_EX_R && requestType == Constants.REQUEST_TYPE_EX_R) {
							subjectRequest.requestReason = null
							subjectRequest.reasonText = null
						}
						
						//if request for resi school exemption (EXR) has been changed from COMPLETED to CANT_COMPLETE or other way round
						//clear corresponding Reason and text
						if((subjectRequest.requestType == Constants.REQUEST_TYPE_EX_R && subjectRequest.assessmentItem == 'COMPLETED' 
							&& requestType == Constants.REQUEST_TYPE_EX_R && assessment == 'CANT_COMPLETE') ||
						(subjectRequest.requestType == Constants.REQUEST_TYPE_EX_R && subjectRequest.assessmentItem == 'CANT_COMPLETE' 
							&& requestType == Constants.REQUEST_TYPE_EX_R && assessment == 'COMPLETED')) 
						{
							subjectRequest.requestReason = null
							subjectRequest.reasonText = null
						}
						//if previous request was for GP and now it has been changed, cleanup assessment item and ext date
						if(requestType == Constants.REQUEST_TYPE_GP) {
							log.debug("Set ext date and assessment for ID " + id)
							subjectRequest.extensionDate = extensionDate
							subjectRequest.assessmentItem = assessment	
						}
						else if (requestType == Constants.REQUEST_TYPE_EX_R) {
							log.debug("Set assessment " + assessment + " for ID " + id)
							subjectRequest.assessmentItem = assessment
						}
						else if (requestType == Constants.REQUEST_TYPE_EX_C){
							subjectRequest.extensionDate = null
							subjectRequest.assessmentItem = assessment
						}
						else
						{
							subjectRequest.extensionDate = null
							subjectRequest.assessmentItem = null
						}
						subjectRequest.requestType = requestType
						subjectRequest.activityDate = DateUtils.sysdate()
						subjectRequest.save(flush: true, failOnError: true)
					//}
					
					true
				}
				else if(i !='0' && id.toInteger() == 0) //new subject selection, add a new record
				{
					log.debug("requestType " + requestType + " assessment " + assessment)
					def requestReason, reasonText
					def query = Request.where{ guid == guid && requestType != 'EXR'}
					def GPSubjectList = query.list()
					
					if (GPSubjectList.size()>0) {
						requestReason = GPSubjectList[0].requestReason
						reasonText = GPSubjectList[0].reasonText
					}
					//insert a new record
					Request subjectRequest = new Request(guid: guid, 
					pidm: params.person.pidm,
					statusId: RequestStatus.get(Constants.STATUS_NOT_SUBMITTED),
					requestType: requestType,
					crn: subjectOffering[0],
					session: subjectOffering[1],
					assessmentItem: assessment,
					extensionDate: extensionDate,
					requestReason: (requestType == Constants.REQUEST_TYPE_EX_R && (assessment == 'COMPLETED' || assessment == 'PASSED'))? null : requestReason, 
					reasonText: (requestType == Constants.REQUEST_TYPE_EX_R && (assessment == 'COMPLETED' || assessment == 'PASSED'))? null : reasonText, 
					counselling: request.counselling, 
					hasProvidedDocumentation: request.hasProvidedDocumentation,
					hasOptionalDocumentation: request.hasOptionalDocumentation,
					hasSubmitted: Constants.STATUS_NOT_SUBMITTED,
					activityDate: DateUtils.sysdate(),
					createdDate: DateUtils.sysdate())
					subjectRequest.save(flush: true, failOnError: true)
					
					params."id${i}" = subjectRequest.id
					//log.debug("New ID : "+ subjectRequest.id + " params id = " + params."id${i}")
				}
				
			}
		}
		
		// Save & return guid. 
		return guid
	}

	/**
	 * @param params
	 * @return
	 */
	private def deleteApplication(Map params) {
		
		def specialConRequestList = Request.findAllByGuid(params.guid)
		def appCntr=0, docCntr=0

		if(specialConRequestList)
		{
			specialConRequestList.each { request -> 
				request.delete(flush: true, failOnError: true)
				appCntr+=1
			}
		}

		def supportingDocumentList = SupportingDocument.findAllByGuid(params.guid)
		
		if(supportingDocumentList)
			{
				supportingDocumentList.each { doc -> 
					doc.delete(flush: true, failOnError: true)
					docCntr+=1
				}

			}
		log.debug("Deleted SC Application for GUID : ${params.guid} Total ${appCntr} application(s) and ${docCntr} supporting documents deleted.")		
	}

	/**
	 * @param params
	 * @return
	 */
	private def deleteSupportingDocument(String guid, int requestId) {
		def supportingDocumentList 
		def query
		def docCntr=0
		if (guid != null && requestId == 0) {
			query = SupportingDocument.where{guid == guid}
			supportingDocumentList = query.list()
		}
		else if(guid != null && requestId > 0)
		{
		    query = SupportingDocument.where{guid == guid && requestid == requestId}
			supportingDocumentList = query.list()
		}
		else
		{
		  log.debug("Invalid request to delete supporting Document.")
		  return
		}
		
		
		if(supportingDocumentList)
			{
				supportingDocumentList.each { doc -> 
					doc.delete(flush: true, failOnError: true)
					docCntr+=1
				}

			}
		log.debug("Deleted ${docCntr} supporting documents for GUID : ${guid} and RequestID : ${requestId}")
	}


	/**
	 * @param params
	 * @return
	 */
	private def saveReason(Map params) {
			
		def guid = params.guid
		def supportDocLater = 0
		log.debug("GUID for Reason: ${guid}")
		def file1 = request.getFile('documentFile1')
		def file2 = request.getFile('documentFile2')
		def file3 = request.getFile('documentFile3')
		def docID = 0
		def doc01Id = Integer.parseInt(params.doc01Id)
		def doc02Id = Integer.parseInt(params.doc02Id)
		def doc03Id = Integer.parseInt(params.doc03Id)

		
		log.debug("doc01Id, doc02Id and doc03Id " + doc01Id + ", " + doc02Id + ", " + doc03Id)
			//if in edit mode and user decided to remove\delete the mandatory doco, delete it from the DB
			if (params.mode == 'edit' && params.removeDoc01Flag == 'true') {
				def query = SupportingDocument.where{guid == params.guid && docid == params.doc01Id && requestid==0}
				def supportingDocumentList = query.list()
		
				if(supportingDocumentList)
					{
						supportingDocumentList.each { doc -> 
							doc.delete(flush: true, failOnError: true)
							supportDocLater = 0
							log.debug("Mandatory Document deleted.")		
						}

					}
			}
			//if in edit mode and user decided to remove\delete the first additional doco, delete it from the DB
			if (params.mode == 'edit' && params.removeDoc02Flag == 'true') {
				def query = SupportingDocument.where{ guid == params.guid && docid == params.doc02Id && requestid==0}
				def supportingDocumentList = query.list()
				
				if(supportingDocumentList)
					{
						supportingDocumentList.each { doc -> 
							doc.delete(flush: true, failOnError: true)
							log.debug("First additional Document deleted.")		
						}

					}
			}
			//if in edit mode and user decided to remove\delete the second additional doco, delete it from the DB
			if (params.mode == 'edit' && params.removeDoc03Flag == 'true') {
				def query = SupportingDocument.where{guid == params.guid && docid == params.doc03Id && requestid==0}
				def supportingDocumentList = query.list()
		
				if(supportingDocumentList)
					{
						supportingDocumentList.each { doc -> 
							doc.delete(flush: true, failOnError: true)
							log.debug("Second additional Document deleted.")		
						}

					}
			}
			
			if(file1 && !file1.empty)
			{
			uploadFile(params.mode,guid,0,doc01Id,file1.getBytes(),params.fileName1,file1.getContentType(),1)
			supportDocLater = 1
			}

			if(file2 && !file2.empty)
			uploadFile("new",guid,0,doc02Id,file2.getBytes(),params.fileName2,file2.getContentType(),0)

			if(file3 && !file3.empty)
			uploadFile("new",guid,0,doc03Id,file3.getBytes(),params.fileName3,file3.getContentType(),0)

			
		try {
			//find corresponding SC request to update the reason and reason text
			def specialConRequestList = Request.findAllByGuid(guid)
				specialConRequestList.each{ specialConRequest ->
				if(specialConRequest.assessmentItem != 'COMPLETED' && specialConRequest.assessmentItem != 'PASSED')
				{
				specialConRequest.requestReason = params.reasonType
				specialConRequest.reasonText = params.descText
				specialConRequest.counselling = (params.counselling)?  1 : 0
				specialConRequest.hasProvidedDocumentation = supportDocLater
				specialConRequest.hasOptionalDocumentation = (params.reasonType?.equals(Constants.REASON_TYPE_CI))? 1 : 0
				specialConRequest.activityDate = DateUtils.sysdate()
				specialConRequest.save(flush: true, failOnError: true)
				}
		}
		}
		catch(Exception e) {
			log.debug("*** Error updating Reason details : " + e.getMessage())
		}
		
		// Save & return guid. 
		return guid
	}

/**
	 * @param params
	 * @return
	 * To save reason for an exemption from residential school request
	 */
	private def saveReasonForResSchoolExemption(Map params) {
			
		def guid = params.guid
		
		log.debug("GUID : ${guid}")
		def file1 = request.getFile('documentFile1')
		def hasOptionalDocumentation = null
		def docID = 0
		def doc01Id = Integer.parseInt(params.doc01Id)
		def requestID = Integer.parseInt(params.requestid)
		
		log.debug("doc01Id " + doc01Id)
			//if in edit mode and user decided to remove\delete the mandatory doco, delete it from the DB
			if (params.mode == 'edit' && params.removeDoc01Flag == 'true') {
				def query = SupportingDocument.where{guid == params.guid && docid == params.doc01Id}
				def supportingDocumentList = query.list()
		
				if(supportingDocumentList)
					{
						hasOptionalDocumentation = 0
						supportingDocumentList.each { doc -> 
							doc.delete(flush: true, failOnError: true)
						}

					}
			}
			
			
			if(file1 && !file1.empty)
			{
			uploadFile(params.mode,guid,requestID,doc01Id,file1.getBytes(),params.fileName1,file1.getContentType(),0)
			hasOptionalDocumentation = 1
			}
		
		//find corresponding SC request to update the reason desc text
		def specialConRequestList = Request.findAllById(requestID)
			specialConRequestList.each{ specialConRequest ->
			specialConRequest.reasonText = params.descText
			log.debug(" hasOptionalDocumentation : " + hasOptionalDocumentation)
			if (hasOptionalDocumentation != null) 
			{
				specialConRequest.hasOptionalDocumentation = hasOptionalDocumentation 	
			}
			specialConRequest.activityDate = DateUtils.sysdate()
			specialConRequest.save(flush: true, failOnError: true)
		}
		// Save & return guid. 
		return guid
	}


	/**
	 * @param params
	 * @return
	 */
	private def uploadDocuments(Map params) {
			
		def guid = params.guid
		log.debug("GUID for uploadDocument: ${guid}")
		def mandatoryDocFlag = 0
		def additionalDocFlag = 0
		def file1 = request.getFile('documentFile1')
		def file2 = request.getFile('documentFile2')
		def file3 = request.getFile('documentFile3')
		//Check if there are any existing docs for this app, if found all subsequent uploaded docs should be just ADDITONAL 
		def query = SupportingDocument.where{guid == guid}
		def supportingDocumentList = query.list()
		//The mandatory flag (SWRSPDOC_MANDATORY_FLAG) will be set to 1 for the mandatory document, 2 for all additional requested docs by DSO\assessor
		//check if there were any docs submitted earlier, if not, this upload is for the first set of supporting documents against action required status
		if(supportingDocumentList.size == 0)
			mandatoryDocFlag = 1
		else
		{
			mandatoryDocFlag = 2
			additionalDocFlag = 2
		}

		if(!file1.empty)
		uploadFile("new",guid,0,0,file1.getBytes(),params.fileName1,file1.getContentType(),mandatoryDocFlag)

		if(!file2.empty)
		uploadFile("new",guid,0,0,file2.getBytes(),params.fileName2,file2.getContentType(),additionalDocFlag)

		if(!file3.empty)
		uploadFile("new",guid,0,0,file3.getBytes(),params.fileName3,file3.getContentType(),additionalDocFlag)

		//find corresponding SC request to update the doc provided flag and change the status from ACTION_REQUIRED to PROCESSING
		def specialConRequestList = Request.findAllByGuid(guid)
			specialConRequestList.each{ specialConRequest ->
			if(Integer.parseInt(specialConRequest.statusId.toId()) == Constants.STATUS_ACTION_REQUIRED)
			{
			specialConRequest.hasProvidedDocumentation = 1
			specialConRequest.statusId = RequestStatus.get(Constants.STATUS_PROCESSING)
			specialConRequest.activityDate = DateUtils.sysdate()
			specialConRequest.save(flush: true, failOnError: true)
			}
		}
		// Save & return guid. 
		return guid
	}

	/**
	 * @param params
	 * @return
	 */
	private def uploadFile(String mode, String guid, int requestID, int docID, byte[] content, String fileName, String contentType, int mandatory) {

				SupportingDocument supportingDocument = new SupportingDocument()
				if (mode == 'edit' && docID > 0) {
					def query = SupportingDocument.where{guid == guid && docid == docID}
					def supportingDocumentList = query.list()
					if(supportingDocumentList.size>0)	
					{
					supportingDocument = supportingDocumentList[0]
					docID = supportingDocument.docid
					}
				}
				else if(docID == 0)
					docID = getMaxDocID(guid)+1
				
				log.debug("** Max Doc ID = "+docID)
				supportingDocument.guid = guid
				supportingDocument.requestid = requestID
				supportingDocument.docid = docID
				supportingDocument.document = content
				supportingDocument.fileName = fileName
				
				if(contentType.indexOf('officedocument') > 0)
					supportingDocument.mimeType = 'application/msword'
				else
					supportingDocument.mimeType = contentType
				supportingDocument.mandatory = mandatory 
				supportingDocument.mandatoryOverride = 0
				supportingDocument.requestDate = DateUtils.sysdate()
				supportingDocument.activityDate = DateUtils.sysdate()
				log.debug("******************** File upload START : " + DateUtils.sysdate())
				supportingDocument.save(flush: true, failOnError: true)
				log.debug("******************** File upload END : " + DateUtils.sysdate())
	}


	/**
	 * @param params
	 * @return
	 */
	private def getMaxDocID(String guid) {
		def supportingDocumentList = SupportingDocument.executeQuery("SELECT MAX(docid) FROM SupportingDocument WHERE SWRSPDOC_GUID = '"+guid +"'")
		def maxDocId = 0
		if (supportingDocumentList.size > 0) {
			if(supportingDocumentList[0] != null)
			  maxDocId = supportingDocumentList[0]
			log.debug("Max docID from DB is "+maxDocId)
		}
		else
		log.debug("Unable to find max docid for the supplied GUID " + guid)
	return maxDocId
	}
	/**
	 * @param params
	 * @return
	 */
	private def submitApplication(Map params) {
		def guid = params.guid
		
		log.debug("GUID for Submit Application: ${guid}")
		def specialConRequestList = Request.findAllByGuid(guid)
		try {
			specialConRequestList.each{ specialConRequest ->
			specialConRequest.hasSubmitted = 1
			specialConRequest.statusId = RequestStatus.get(Constants.STATUS_SUBMITTED)
			specialConRequest.requestDate = DateUtils.sysdate() 
			specialConRequest.activityDate = DateUtils.sysdate()
			specialConRequest.save(flush: true, failOnError: true)
		}
		}
		catch(Exception e) {
			log.debug(e.getMessage())
		}
		return guid
	}

	/**
	 * Get application details based on the GUID
	 * @param guid
	 * @return
	 */
	private def getApplicationDetails(String guid)
	{
		def subjectList = []
		def requestDetails = [:]
		def supportingDocuments = []
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = []
		def currentTerms = enterpriseDataService.getCurrentTerms()
		def courseDetails = []
		def specialConRequestList = Request.findAllByGuid(guid)
		def mandatorySupportingDocsSubmitted = true
		def requestDate = null
		def statusDate = null
		def status = ''
		def statusCode = null
		def otherSCRequestsFlag = 0
		def resiSchoolExemptionPassedFlag = 0
		def resiSchoolExemptionCompletedFlag = 0
		
		if(specialConRequestList.find { subject -> (subject.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("PASSED")) })
		resiSchoolExemptionPassedFlag=1
		
		if(specialConRequestList.find { subject -> (subject.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("COMPLETED")) })
		resiSchoolExemptionCompletedFlag=1

		if(specialConRequestList.find { subject -> (subject.requestType?.equals(Constants.REQUEST_TYPE_GP) || subject.requestType?.equals(Constants.REQUEST_TYPE_EX_C) || 
		subject.requestType?.equals(Constants.REQUEST_TYPE_SX) || subject.requestType?.equals(Constants.REQUEST_TYPE_AW)) ||
		(subject.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && subject.assessmentItem?.equals("CANT_COMPLETE")) || 
		(subject.requestType?.equals(Constants.REQUEST_TYPE_EX_R) && subject.requestReason?.equals(Constants.REASON_TYPE_CI)) })
		otherSCRequestsFlag=1

		
		if(specialConRequestList)
		{
			userDetails = enterpriseDataService.getPersonForPIDM(specialConRequestList[0].pidm)
			courseDetails = enterpriseDataService.getCourseDetails(userDetails.pidm, currentTerms.termCode)
			specialConRequestList.each { request -> 
					if (request.requestDate != null) 
					requestDate = DateUtils.formatDate(new Date(request.requestDate.getTime()), "dd/MM/yyyy")
					if (request.statusDate != null) 
					statusDate = DateUtils.formatDate(new Date(request.statusDate.getTime()), "dd/MM/yyyy")
					status = request.statusId.getTitle()
					statusCode = request.statusId.getId()
					def subject = enterpriseDataService.getSubject(request.crn, request.session)
					if(subject)
					{
						def campusDetails = enterpriseDataService.getCampusDetails(subject.campus)
						def mode = (Constants.MODE_INTERNAL.equalsIgnoreCase(subject.mode)) ? Constants.MODE_INTERNAL_DISPLAY : Constants.MODE_DISTANCE_DISPLAY
						def requestType = request.requestType
						def requestTypeCode = request.requestType
						def assessmentItem = request.assessmentItem
						def reason = request.requestReason
						def extensionDate
						if(request.extensionDate){
							extensionDate = DateUtils.formatDate(request.extensionDate, 'dd/MM/yyyy')
						}
						switch (request.requestType) {
					         case Constants.REQUEST_TYPE_GP: requestType = "An extension past the end of session to complete an assignment, assessment or placement"; 
					         								 break;
							 case Constants.REQUEST_TYPE_EX_C: requestType = "An extension past the end of session to complete a compulsory residential school"; 
					         								 break;
					         case Constants.REQUEST_TYPE_SX: requestType = "A supplementary final exam"; 
					         								 break;					         
					         case Constants.REQUEST_TYPE_AW: requestType = "To withdraw from a subject after census date"; 
					         								 break;					         
					         case Constants.REQUEST_TYPE_EX_R: requestType = "An exemption or partial exemption from a compulsory residential school"; 
					         								 break;					         
					         default: requestType = "Unknown request type";
					      }
					      
					    switch (request.requestReason) {
					         case Constants.REASON_TYPE_MED_ABI: reason = "Medical reasons - Acute/brief illness"; break;
					         case Constants.REASON_TYPE_MED_EI: reason = "Medical reasons - Extended illness"; break;
					         case Constants.REASON_TYPE_FPR: reason = "Family/personal reasons"; break;
					         case Constants.REASON_TYPE_ER: reason = "Employment related"; break;
					         case Constants.REASON_TYPE_AI: reason = "Administrative Issues"; break;
					         case Constants.REASON_TYPE_RC: reason = "Representative commitments"; break;
					         case Constants.REASON_TYPE_MC: reason = "Military commitments"; break;
					         case Constants.REASON_TYPE_LC: reason = "Legal commitments"; break;
							 case Constants.REASON_TYPE_CI: reason = "Critical Incident"; break;
					         case Constants.REASON_TYPE_OE: reason = "Other events"; break;
					         default: reason = "Unknown reason";
					      }
					   
						subjectList.add([subjectDisplay: "${subject.subjectCode} (${subject.termCode}_${campusDetails.campusName}_${mode})", 
									  subject: subject.subjectCode, 
									  termCode: subject.termCode, 
									  campus: campusDetails.campusName, 
									  mode: mode,
									  requestTypeCode: requestTypeCode, 
									  requestType: requestType, 
									  assessmentItem: assessmentItem, 
									  reason: reason, 
									  reasonText: request.reasonText,
									  requestId: request.id,
									  extensionDate:extensionDate])
						//if(mandatorySupportingDocsSubmitted==false)
						//mandatorySupportingDocsSubmitted = request.hasProvidedDocumentation
					}
				}
				
				
				requestDetails  = [	 firstName: userDetails.firstName,
									 lastName: userDetails.lastName,
									 emailAddress: userDetails.emailAddress,
									 studentId: userDetails.id,
									 requestDate: requestDate,
									 statusDate: statusDate,
									 status: status,
									 statusCode: statusCode]

				def supportingDocumentList = SupportingDocument.findAllByGuid(guid, [sort: ['requestid': 'asc', 'mandatory': 'desc', 'activityDate': 'asc']])
				if(supportingDocumentList)
					{
						supportingDocumentList.each { doc -> 
							supportingDocuments.add([fileName: doc.fileName, content: Base64.getEncoder().encodeToString(doc.document), mimeType: doc.mimeType, docId: doc.docid, mandatory: doc.mandatory, requestid: doc.requestid])
						}

					}
				}
				

				return [guid: params.guid, userDetails: userDetails, 
				subjectList: subjectList, requestDetails: requestDetails, supportingDocuments: supportingDocuments, courseDetails: courseDetails, 
				mandatorySupportingDocsSubmitted: mandatorySupportingDocsSubmitted, otherSCRequestsFlag: otherSCRequestsFlag, 
				resiSchoolExemptionPassedFlag: resiSchoolExemptionPassedFlag, 
				resiSchoolExemptionCompletedFlag: resiSchoolExemptionCompletedFlag]
	}



	/**
	 * Send request submission confirmation email to the student
	 * @param guid
	 * @return
	 */
	private def sendConfirmationEmailAppsWithSupportingDocs(String guid)  {

		if (!guid) {
			return 'missing-GUID'
		}

		def result = getApplicationDetails(guid)
		String emailSubject = "${result.requestDetails.studentId}: ${result.requestDetails.firstName}, your request has been received"
		//Resource imageResourceTwitter = assetResourceLocator.findAssetForURI('social-icon-twitter-circle.png')
		//Resource imageResourceLinkedIn = assetResourceLocator.findAssetForURI('social-icon-linkedin-circle.png')
		if (!result.mandatorySupportingDocsSubmitted) 
			emailSubject = emailSubject + ": Action Required"
		
		try {
			if (result.mandatorySupportingDocsSubmitted) {
				mailService.sendMail {
					to "abc@xyz.com"
					subject emailSubject
					html view: "/emails/EmailConfirmationWithSupportingDocs", model: [guid: params.guid, userDetails: result.userDetails, 
					subjectList: result.subjectList, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
					courseDetails: result.courseDetails, otherSCRequestsFlag: result.otherSCRequestsFlag, 
					resiSchoolExemptionPassedFlag: result.resiSchoolExemptionPassedFlag, 
					resiSchoolExemptionCompletedFlag: result.resiSchoolExemptionCompletedFlag]
				}
			}
			else{
				mailService.sendMail {
					to "abc@xyz.com"
					subject emailSubject
					html view: "/emails/EmailConfirmationWithoutSupportingDocs", model: [guid: params.guid, userDetails: result.userDetails, 
					subjectList: result.subjectList, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
					courseDetails: result.courseDetails,exemptionReason:ExemptionReason]
				}
			}
		} catch (Exception e) {
			log.error('Error sending application submission email', e)
			throw new Exception('Error sending application submission email', e)
		}

		return 'success'
	}
	
	/**
	 * Send emails (one per subject request) to the DSO
	 * @param guid
	 * @return
	 */
	private def sendDSOEmail(String guid)  
	{

		if (!guid) {
			return 'missing-GUID'
		}
		def emailSubject = ""
		def result = getApplicationDetails(guid)
		def subjectList = result.subjectList
		def docList = result.supportingDocuments
		def byte[] docByte1, docByte2, docByte3, docByte4
		def fileName1, fileName2, fileName3, fileName4
		def mimeType1, mimeType2, mimeType3, mimeType4
		
		docList.eachWithIndex { doc, j -> 
			
				if (j==0 && docByte1==null && doc.requestid==0) {
					docByte1 = Base64.getDecoder().decode(doc.content)
					fileName1=doc.fileName
					mimeType1 = doc.mimeType
				}
				
				if (j==1 && docByte2==null && doc.requestid==0) {
					docByte2 = Base64.getDecoder().decode(doc.content)
					fileName2=doc.fileName
					mimeType2 = doc.mimeType
				}
				if (j==2 && docByte3==null && doc.requestid==0) {
					docByte3 = Base64.getDecoder().decode(doc.content)
					fileName3=doc.fileName
					mimeType3 = doc.mimeType
				}
				if (docByte4==null && doc.requestid>0) {
					docByte4 = Base64.getDecoder().decode(doc.content)
					fileName4=doc.fileName
					mimeType4 = doc.mimeType
				}
				
			}
		
		subjectList.each { sub ->  
			
			emailSubject = ""
			
			switch (sub.requestTypeCode) {
		         case Constants.REQUEST_TYPE_GP: emailSubject = "SpC-GP"
		         								 break
				 case Constants.REQUEST_TYPE_EX_C: emailSubject = "SpC-GP"
		         								 break
		         case Constants.REQUEST_TYPE_SX: emailSubject = "SpC-SX"
		         								 break         
		         case Constants.REQUEST_TYPE_AW: emailSubject = "SpC-AW"
		         								 break         
		         case Constants.REQUEST_TYPE_EX_R: emailSubject = "SpC-RES"
		         								 break      
		         default: emailSubject = "Unknown request type"
		      }
			
			emailSubject = emailSubject+"-${result.requestDetails.studentId}-${result.requestDetails.lastName}-${sub.subject}-${sub.campus}/${sub.mode}-${sub.termCode}"
			
			
			try {
				
					if(sub.requestTypeCode == Constants.REQUEST_TYPE_GP || sub.requestTypeCode == Constants.REQUEST_TYPE_SX || sub.requestTypeCode == Constants.REQUEST_TYPE_AW || sub.requestTypeCode == Constants.REQUEST_TYPE_EX_C 
						|| (sub.requestTypeCode == Constants.REQUEST_TYPE_EX_R && sub.assessmentItem == 'CANT_COMPLETE'))
					{

						if(docByte1 != null && docByte2 != null && docByte3 != null)
						{
							mailService.sendMail {
								multipart true
								to "abc@xyz.com"
								subject emailSubject
								attach(fileName1, mimeType1, docByte1)
								attach(fileName2, mimeType2, docByte2)
								attach(fileName3, mimeType3, docByte3)
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
						}
						else if(docByte1 != null && docByte2 != null)
						{
							mailService.sendMail {
								multipart true
								to "abc@xyz.com"
								subject emailSubject
								attach(fileName1, mimeType1, docByte1)
								attach(fileName2, mimeType2, docByte2)
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
						}
						else if(docByte1 != null)
						{
							mailService.sendMail {
								multipart true
								to "abc@xyz.com"
								subject emailSubject
								attach(fileName1, mimeType1, docByte1)
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
						}
						else if(docByte1 == null)
						{
							mailService.sendMail {
								to "abc@xyz.com"
								subject emailSubject
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
						}
					}
					else if(sub.requestTypeCode == Constants.REQUEST_TYPE_EX_R && sub.assessmentItem == 'COMPLETED') 
					{
						if(docByte4 != null)
						{
							mailService.sendMail {
								multipart true
								to "abc@xyz.com"
								subject emailSubject
								attach(fileName4, mimeType4, docByte4)
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
						}
						else
						{
							mailService.sendMail {
								to "abc@xyz.com"
								subject emailSubject
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
						}
					}
					else if(sub.requestTypeCode == Constants.REQUEST_TYPE_EX_R && sub.assessmentItem == 'PASSED') 
					{
						mailService.sendMail {
								to "abc@xyz.com"
								subject emailSubject
								html view: "/emails/DSOEmailNotification", model: [guid: params.guid, userDetails: result.userDetails, 
								subject: sub, requestDetails: result.requestDetails, supportingDocuments: result.supportingDocuments, 
								courseDetails: result.courseDetails]
								} 
					}
					
				}
				catch (Exception e) {
					log.error('Error sending DSO email', e)
					//throw new Exception('Error sending DSO email', e)
				}
		
	 	}
	 
		return 'success'
	}
}
 