package au.edu.csu.specialcons


import grails.transaction.Transactional

import org.apache.commons.logging.LogFactory
import org.grails.web.util.WebUtils

import au.edu.csu.specialcons.api.domain.Task
import au.edu.csu.utils.DateUtils

@Transactional
class TaskInboxService {

	def enterpriseDataService
	def restService
	private static final log = LogFactory.getLog(this)

	def updateDocumentForDso(String guid,String recommendation, String reason, String chkDocId) {
		try {
			def supoortingDocList = SupportingDocument.findAllByGuid(guid)
			supoortingDocList.each { supportingDoc ->
				if(chkDocId && supportingDoc.docid == Long.parseLong(chkDocId)){
					supportingDoc.mandatoryOverride = 1
				}
				else{
					supportingDoc.mandatoryOverride = 0
				}
				supportingDoc.recommendation = recommendation
				supportingDoc.reason = reason
				//log.info("Updating supporting document with ${supportingDoc}")
				supportingDoc.save(flush: true, failOnError: true)
				//log.info("Update supporting document ${supportingDoc}")
				if (supportingDoc?.hasErrors()) {
					log.error("Supporting Document guid ${guid} having document id ${supportingDoc.docid} is not saved. Domain Errors: ${supportingDoc?.errors}")
				}
			}
			
		} catch (Exception e) {
			log.error("Error update supporting document: ${e.getMessage()}")
			return null
		}
	}
	
	Task fillTaskObjFromTask(Task taskObj,def task,def userName){
		taskObj.taskId = Long.parseLong(task.TaskID)
		
		if(task.TaskInfo.lastModifiedDate){
			String dateStr=task.TaskInfo.lastModifiedDate
			dateStr = DateUtils.convertApiDate(dateStr)
			taskObj.lastActionDateStr = DateUtils.formatDateStr(dateStr, "MMM dd yyyy HH:mm:ss","dd-MMM-yyyy HH:mm");
			//log.debug("dateStr ${dateStr} taskObj.lastActionDateStr ${taskObj.lastActionDateStr}")
			taskObj.lastActionDate = DateUtils.parseDate(taskObj.lastActionDateStr, "dd-MMM-yyyy")
			String dateExpireStr=task.TaskInfo.expireDate
			dateExpireStr = DateUtils.convertApiDate(dateExpireStr)
			dateExpireStr = DateUtils.formatDateStr(dateExpireStr, "MMM dd yyyy HH:mm:ss","dd-MMM-yyyy HH:mm");
			Date expireDate = DateUtils.parseDate(dateExpireStr, "dd-MMM-yyyy")
			//log.debug(" taskObj.lastActionDate ${taskObj.lastActionDate} expireDate ${expireDate}")
			taskObj.isNotify =  taskObj.lastActionDate > expireDate
			
		}
		else{
			taskObj.isNotify = true
		}
		
		if(task.TaskInfo.acceptedByList){
			taskObj.assignedTo = task.TaskInfo.acceptedByList[0]
			if (userName.equals(taskObj.assignedTo)){
				taskObj.assignedToName = Task.ASSIGNED_ME
			}
			else if(taskObj.assignedTo){
				Person currentPerson = enterpriseDataService.getPersonForUsername(taskObj.assignedTo)
				taskObj.assignedToName = currentPerson.firstName + " " + currentPerson.lastName
			}
		}
		else{
			taskObj.assignedToName = Task.ASSIGNED_NOT
		}
		def studentObj
		def requestObj = task.TaskData.specialConsiderationRequest?.requests
		if(task.TaskData.specialConsiderationRequest && requestObj){
			taskObj.guid = requestObj[0].requestGuid
			studentObj = requestObj[0].student
			taskObj.studentId = Long.parseLong(studentObj.studentId)
			taskObj.studentName = studentObj.studentGivenName + " " + studentObj.studentSurname
		}
		
		return taskObj
	}
	
	def performAssignment(def assignee,def taskId,def userName){
		def personMap=[
			'Asilika Kumar':'askumar',
			'Bronwyn Norrie':'bnorrie',
			'Catherine Cranston':'ccransto',
			'Elizabeth Purcell':'epurcell',
			'Elira Willan':'ewillan',
			'Fiona Reedy':'freedy',
			'Helen Syme':'hsyme',
			'Janice Korner':'jkorner',
			'Julie Linsell':'jlinsell',
			'Jane Press':'jpress',
			'Jason Hay':'jhay06',
			'Laura Bloomfield':'lbloomfi',
			'Lorem Ipsum':'lipsum',
			'Maria Drinkwater':'mdrinkwa',
			'Marilyn Goldsmith':'mgoldsmi',
			'Marisa King':'mking20',
			'Natalie Raczkowski':'nraczkow',
			'Patsy Suckling':'psucklin',
			'Rachael Peck':'rpeck03',
			'Suzanne Jones':'sjones',
			'Sushma Sharma':'susharma',
			'Vicki Hennock':'vhennock']
		
		if(assignee){
			userName = personMap.get(assignee)
		}
		
		def url ="rest/specialConsideration/api/v1/tasks/${taskId}"
		def taskJson
		try{
			taskJson = restService.doCacheableRestRequest(RestService.API_TASK, url)
		}
		catch(Exception e){
			log.error("Error in getting task from api",e)
		}
		taskJson.tasks[0].TaskInfo.acceptedByList[0]=userName
		
		//log.info(" taskJson ${taskJson.toString()}")
		def responseJson = restService.doRestPost(RestService.API_TASK, url, taskJson.toString())
		 
		//log.info(" responseJson ${responseJson}")
		return userName
	}
	
	def sendForAssessment(def taskId){
		
		def url ="rest/specialConsideration/api/v1/tasks/${taskId}"
		def taskJson
		try{
			taskJson = restService.doCacheableRestRequest(RestService.API_TASK, url)
		}
		catch(Exception e){
			log.error("Error in getting task from api",e)
		}
		taskJson.tasks[0].TaskInfo.status="completed"
		
		//log.info(" taskJson ${taskJson.toString()}")
		def responseJson = restService.doRestPost(RestService.API_TASK, url, taskJson.toString())
		 
		//log.info(" responseJson ${responseJson}")
	}
}
