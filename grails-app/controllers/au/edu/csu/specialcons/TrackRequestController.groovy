package au.edu.csu.specialcons

import grails.converters.JSON
import groovy.util.logging.Slf4j
import au.edu.csu.specialcons.exceptions.ApplicationException
import au.edu.csu.specialcons.security.SecurityService
import au.edu.csu.utils.AppUtils
import au.edu.csu.utils.DateUtils
import au.edu.csu.utils.StringUtils
import java.time.LocalDate

/**
 * Controller for the Special Consideration tracking request form.
 *
 * @author 		Farhan Rayani <a href="frayani@csu.edu.au">frayani@csu.edu.au</a>
 * @since 		16-Jan-2017
 */
@Slf4j
class TrackRequestController {

	EnterpriseDataService enterpriseDataService
	EnterpriseDataFacadeService enterpriseDataFacadeService
	RestService restService
	SecurityService securityService

	
	/**
	 * Returns JSON of subject details for a given CRN and term.
	 */
	def index() {
		log.debug("Controller: ${controllerName}, Action: ${actionName}") 
		def requestList = []
		def user = securityService.getRemoteUser(request.getRemoteUser(), null)
		def userDetails = enterpriseDataService.getPersonForUsername(user)
		def requestCriteria = Request.createCriteria()
		if (!userDetails) {
			throw new ApplicationException("Unable to determine user from login ID ${user}.")
		}
		
		 
		try {

				def specialConRequestList = Request.findAllByPidm(userDetails.pidm, [sort: ['statusId': 'asc', 'requestDate': 'desc', 'createdDate': 'desc']])
				log.debug("Student Request Tracking for PIDM : "+userDetails.pidm)
				if(specialConRequestList)
				{
					specialConRequestList.each { request -> 
							def subject = enterpriseDataService.getSubject(request.crn, request.session)
							if(subject)
							{
								def requestType = request.requestType
								def reason = request.requestReason
								def requestDate = null
								def estimatedCompletionDate = null
								def expirationDate = null
								def actionRequiredExpirationDate = null
								def statusDate = null
								def createdDate = null
								def statusIdSortChar = null
								//DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("d/MM/yyyy")

								if (request.requestDate != null) 
								{
									requestDate = DateUtils.formatDate(new Date(request.requestDate.getTime()), "dd/MM/yyyy")
									estimatedCompletionDate = DateUtils.addWorkDays(requestDate, 5)
								}
								
								
								if (request.statusDate != null) 
								{
									statusDate = DateUtils.formatDate(new Date(request.statusDate.getTime()), "dd/MM/yyyy")
									//for Action Required Statuses, use the statusDate to calculate the action expiration date which is 14 business days
									if (request.statusId.getId() == 10) {
										actionRequiredExpirationDate = DateUtils.addWorkDays(statusDate, 14)
									}
								}
								if(request.createdDate != null)
								{
								 createdDate = DateUtils.formatDate(new Date(request.createdDate.getTime()), "dd/MM/yyyy")
								 expirationDate = DateUtils.addWorkDays(createdDate, 60)
								}
								switch (request.requestType) {
							         case Constants.REQUEST_TYPE_GP: requestType = "An extension of time to complete an assignment or assessment"; break;
							         case Constants.REQUEST_TYPE_SX: requestType = "To re-sit an exam"; break;
							         case Constants.REQUEST_TYPE_AW: requestType = "To withdraw from a subject"; break;
							         case Constants.REQUEST_TYPE_EX_P: requestType = "An exemption from a compulsory placement, workplace learning, or practical class"; break;
							         case Constants.REQUEST_TYPE_EX_R: requestType = "An exemption or partial exemption from a compulsory residential school"; break;
							         case Constants.REQUEST_TYPE_EX_C: requestType = "An extension past the end of session to complete a compulsory residential school"; break;
							         default: requestType = "Unknown request type";
							      }
							    
							    switch (request.statusId.getId()) {
							         case Constants.STATUS_ACTION_REQUIRED: statusIdSortChar = 'A'; break;
							         case Constants.STATUS_NOT_SUBMITTED: statusIdSortChar = 'B'; break;
							         case Constants.STATUS_PROCESSING: statusIdSortChar = 'C'; break;
							         case Constants.STATUS_APPROVED: statusIdSortChar = 'D'; break;
							         case Constants.STATUS_VARIED: statusIdSortChar = 'E'; break;
							         case Constants.STATUS_DECLINED: statusIdSortChar = 'F'; break;
							         case Constants.STATUS_CANCELLED: statusIdSortChar = 'G'; break;
							         case Constants.STATUS_EXPIRED: statusIdSortChar = 'H'; break;
							         default: statusIdSortChar = 'X';
							      }
								requestList.add([id: request.id, 
											  guid: request.guid, 
											  subject: "${subject.subjectCode}", 
											  requestType: requestType, 
											  submitted: request.hasSubmitted, 
											  dateSubmitted: requestDate, 
											  estimatedCompletionDate: estimatedCompletionDate, 
											  expirationDate: expirationDate, 
											  actionRequiredExpirationDate: actionRequiredExpirationDate, 
											  createdOn: createdDate, 
											  statusDate: statusDate, 
											  documentationProvided: request.hasProvidedDocumentation, 
											  status: request.statusId.getTitle().toUpperCase(),
											  statusCode: request.statusId.getId(),
											  statusCodeSortChar: statusIdSortChar])
							}
						}
				}
		}
		catch(Exception e) {
			log.debug(e.getMessage())
		}
		
		render(view: 'index', model: [requestList: requestList, headerText: "Track or Update Your Requests"])
		
	}
	
	def statusRequest() {
		render(view: 'statusRequest')
	}
}
