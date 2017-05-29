package au.edu.csu.specialcons


import grails.converters.JSON
import groovy.json.JsonBuilder
import groovy.util.logging.Slf4j
import au.edu.csu.specialcons.api.domain.Task
import au.edu.csu.specialcons.exceptions.ApplicationException
import au.edu.csu.specialcons.security.SecurityService
import au.edu.csu.utils.AppUtils
import au.edu.csu.utils.DateUtils

/**
 * Controller for the task inbox for student manager.
 *
 * @author 		Farhan Rayani <a href="frayani@csu.edu.au">frayani@csu.edu.au</a>
 * @since 		18-Jan-2017
 */
@Slf4j
class TaskInboxController {

	EnterpriseDataService enterpriseDataService
	EnterpriseDataFacadeService enterpriseDataFacadeService
	SecurityService securityService
	TaskInboxService taskInboxService
	RestService restService
	
	def index() {
		render(view: 'awaitingRequest')
	}
	
	def awaitingRequest() {
		render(view: 'awaitingRequest')
	}
	
	def studentHistory() {
		render(view: 'studentHistory')
	}
	
	def searchAssignee() {
		render(view: 'searchAssignee')
	}
	
	def dsoAwaitingTask() {
		def url ="rest/specialConsideration/api/v1/tasks?userId=DSA Division Support Officers"
		def jsonResponse
		try{
			jsonResponse = restService.doCacheableRestRequest(RestService.API_TASK, url)
		}
		catch(Exception e){
			log.error("Error in fetching DSO workgroup task",e)
		}
		List<Task> taskList = new ArrayList<Task>();
		Task taskObj
		int notAssigned = 0
		int overdue = 0
		int myTasks = 0
		String userName = securityService.getRemoteUser(request.getRemoteUser(), null)
		Map<String, String> assignMap = new HashMap<String, String>();
		/*assignMap.put("Me", "Farhan")
		assignMap.put("Dewang", "Dewang")
		assignMap.put("Me", "Farhan")
		assignMap.put("Dewang", "Dewang")*/
		
		if (jsonResponse) {
			jsonResponse.tasks.each { task ->
				
				if(task.TaskInfo.status?.equals("active") && task.TaskData.specialConsiderationRequest?.requests){
					taskObj = new Task()
					taskObj = taskInboxService.fillTaskObjFromTask(taskObj, task, userName)
					
					if(!taskObj.isNotify){
						overdue++
					}
					
					if(taskObj.assignedToName.equals(Task.ASSIGNED_ME)){
						assignMap.put(Task.ASSIGNED_TO+Task.ASSIGNED_ME, Task.ASSIGNED_TO+Task.ASSIGNED_ME)
						myTasks++;
					}
					else if(taskObj.assignedToName.equals(Task.ASSIGNED_NOT)){
						assignMap.put(Task.ASSIGNED_NOT, Task.ASSIGNED_NOT)
						notAssigned++;
					}
					else{
						assignMap.put(Task.ASSIGNED_TO+taskObj.assignedTo, Task.ASSIGNED_TO+taskObj.assignedToName)
					}
					
					
					taskList.add(taskObj)
					//log.info(" Task... ${taskList.toString()}")
				}
			}
			//assignMap.put(Task.ASSIGNED_NOT, Task.ASSIGNED_NOT)
		}
		//assignMap.put(Task.ASSIGNED_NOT, Task.ASSIGNED_NOT)
		assignMap.put(Task.ASSIGNED_OVERDUE, Task.ASSIGNED_OVERDUE)
		//log.info(assignMap)
		render(view: 'dsoAwaitingTask',model: ['taskList':taskList,'notAssigned':notAssigned,'overdue':overdue,'myTasks':myTasks,'assignMap':assignMap])
	}
	
	def dsoAwaitingTaskAction(){
		//log.info("${params}")
		String userName = securityService.getRemoteUser(request.getRemoteUser(), null)
		def assignee = params.tags?params.tags : params.tags_bottom
		def taskIds = params.assignChk
		if(taskIds){
			if (taskIds.class.isArray()){
				taskIds.each {taskId->
					log.debug("Assigning taskId ${taskId} to userName ${assignee}")
					taskInboxService.performAssignment(assignee, taskId, userName)
				}
			}
			else{
				log.debug("Assigning taskId ${taskIds} to userName ${assignee}")
				taskInboxService.performAssignment(assignee, taskIds, userName)
			}
		}
		
		
		redirect(action: "dsoAwaitingTask")
	}
	
	def dsoProcessRequest() {
		log.debug("Controller: ${controllerName}, Action: ${actionName}, params ${params}")
		
		if (!params.guid || !params.taskId || !params.assignedToName) {
			redirect(uri: AppUtils.getBaseUrl())
			return false
		}
		log.debug("GUID: ${params.guid} TaskId: ${params.taskId}")
		
		
		
		
		if(params.assignedToName!=Task.ASSIGNED_ME){
			flash.message = "This request is not assigned to you. To make your assessment, enter your username in Assign Request to and click Assign."
		}
		
		def specialConRequestList = Request.findAllByGuid(params.guid)
		
		def subjectList = []
		def requestDetails = [:]
		def supportingDocuments = []
		
		
		
		if(specialConRequestList)
		{
			def userDetails = enterpriseDataService.getPersonForPIDM(specialConRequestList[0].pidm)
			def currentTerms = enterpriseDataService.getCurrentTerms()
			def courseDetails = enterpriseDataService.getCourseDetails(specialConRequestList[0].pidm, currentTerms.termCode)
			
			specialConRequestList.each { request ->
					def subject = enterpriseDataService.getSubject(request.crn, request.session)
					if(subject)
					{
						def campusDetails = enterpriseDataService.getCampusDetails(subject.campus)
						def mode = (Constants.MODE_INTERNAL.equalsIgnoreCase(subject.mode)) ? Constants.MODE_INTERNAL_DISPLAY : Constants.MODE_DISTANCE_DISPLAY
						def requestType = request.requestType
						def reason = request.requestReason
						switch (request.requestType) {
							 case Constants.REQUEST_TYPE_GP: requestType = "An extension of time to complete an assignment or assessment"; break;
							 case Constants.REQUEST_TYPE_SX: requestType = "To re-sit an exam"; break;
							 case Constants.REQUEST_TYPE_AW: requestType = "To withdraw from a subject"; break;
							 case Constants.REQUEST_TYPE_EX_P: requestType = "An exemption from a compulsory placement, workplace learning, or practical class"; break;
							 case Constants.REQUEST_TYPE_EX_R: requestType = "An exemption or partial exemption from a compulsory residential school"; break;
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
							 case Constants.REASON_TYPE_OE: reason = "Other events"; break;
							 default: reason = "Unknown reason";
						  }
						subjectList.add([subjectDisplay: "${subject.subjectCode} (${subject.termCode}_${campusDetails.campusName}_${mode})",
									  requestType: requestType,
									  reason: reason,
									  reasonText: request.reasonText,
									  dateSubmitted: request.requestDate])
					}
				}
				
				requestDetails  = [	 firstName: userDetails.firstName,
									 lastName: userDetails.lastName,
									 emailAddress: userDetails.emailAddress,
									 studentId: userDetails.id]

				def supportingDocumentList = SupportingDocument.findAllByGuid(params.guid,[sort: 'mandatory', order: 'desc'])
				if(supportingDocumentList)
					{
						supportingDocumentList.each { doc ->
							supportingDocuments.add([fileName: doc.fileName, content: Base64.getEncoder().encodeToString(doc.document), mimeType: doc.mimeType, 
								docId: doc.docid,activityDate:doc.activityDate,mandatory:doc.mandatory,mandatoryOverride:doc.mandatoryOverride,recommendation:doc.recommendation,reason:doc.reason])
						}

					}
		def supportingDocumentSel 
		if(supportingDocuments.size()>0){
			supportingDocumentSel = supportingDocuments.get(0)
		}		
		
		render(view: 'dsoProcessRequest', model: [guid: params.guid, taskId:params.taskId, assignedToName:params.assignedToName,userDetails: userDetails,
				subjectList: subjectList, requestDetails: requestDetails, supportingDocuments: supportingDocuments, courseDetails: courseDetails,
				supportingDocumentSel:supportingDocumentSel,headerText: "Action Student Requests"])
		}
		else{
			/* error page */
		}
	}
	
	def dsoProcessRequestAction() {
		log.debug("Controller: ${controllerName}, Action: ${actionName} ${params}")
		def taskJson
		def assignedUserName
		String userName = securityService.getRemoteUser(request.getRemoteUser(), null)
		if(params.assignBtn){
			assignedUserName = taskInboxService.performAssignment(params.tags, params.taskId, userName)
		}
		else{
			log.info("Save support document on params ${params}")
			taskInboxService.updateDocumentForDso(params.guid, params.selRecommendation, params.selRej,params.madatoryChk)
			if(params.sendAssessment){
				log.info("send for assessment for task id ${params.taskId}")
				taskInboxService.sendForAssessment(params.taskId)
			}
		}
		if(!params.tags || userName?.equals(assignedUserName) ){
			params.tags='Me'
		}
		
		if(params.sendAssessment){
			redirect(action: "dsoAwaitingTask")
		}
		else{
			redirect(action: "dsoProcessRequest", params: [guid: params.guid,taskId:params.taskId,assignedToName:params.tags])
		}
	}
	
	
}
