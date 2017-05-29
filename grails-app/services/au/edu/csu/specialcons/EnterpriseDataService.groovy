package au.edu.csu.specialcons

import grails.transaction.Transactional
import groovy.sql.Sql
import groovy.util.logging.Slf4j
import au.edu.csu.specialcons.exceptions.RestException

/**
 * Enterprise Data Service responsible for all enterprise data interaction for the Special Consideration Application.
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		14-NOV-2016
 */
@Transactional
@Slf4j
class EnterpriseDataService {

	def dataSource
	RestService restService
	RestProxyService restProxyService
	
	/**
	 * Retrieves a list of eligible subjects from the API source. For each subject returned, a display string is generated with the enrolment key.
	 * The enrolment key is in the format <pre><subjectcode>_<session>_<campuscode>_<mode></pre>.
	 * If the student has no eligible subjects, an empty list is returned.
	 * 
	 * @param pidm the student's PIDM from Banner.
	 * @return a list containing eligible subjects.
	 */
	def getEligibleSubjects(int pidm) {
		def subjectList = []
		def url = "/subject/eligibleList/" + pidm
		
		try {
			
			//def jsonResponse = restService.doCacheableRestRequest(RestService.API_CSUAPPS, url)
			def jsonResponse = restProxyService.doCacheableRequest("subject/eligibleList", [pidm: pidm])
			if (jsonResponse) {
				jsonResponse.each { subject ->
					
					def campusDetails = getCampusDetails(subject.campus)
					def mode = (Constants.MODE_INTERNAL.equalsIgnoreCase(subject.mode)) ? Constants.MODE_INTERNAL_DISPLAY : Constants.MODE_DISTANCE_DISPLAY
					if ('Y'.equals(subject.isEligible)) {
						subjectList.add([subjectEnrolment: "${subject.crn}_${subject.termCode}", 
										   subjectDisplay: "${subject.subjectCode} (${subject.termCode}_${campusDetails.campusName}_${mode})", 
										      subjectCode: subject.subjectCode, 
										      		  crn: subject.crn, 
											     termCode: subject.termCode, 
												     mode: subject.mode, 
											   campusCode: subject.campus,
											   termEndDate: subject.termEndDate,
											   census_date: subject.census_date,
										residential_school: subject.residential_school])
					}
				}
			}
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return subjectList
	}
	
	/**
	 * Retrieves the details of a campus from the API source.
	 * 
	 * @param campusCode the code of the campus.
	 * @return the campus details.
	 */
	def getCampusDetails(String campusCode) {
		def campusDetails = [:]
		def url = "/misc/campus/" + campusCode
		
		try {
			//def jsonResponse = restService.doCacheableRestRequest(RestService.API_CSUAPPS, url)
			def jsonResponse = restProxyService.doCacheableRequest("misc/campus", [campusCode: campusCode])
			if (jsonResponse) {
				campusDetails = [campusCode: jsonResponse.campusCode, campusName: jsonResponse.campusName]
			}
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return campusDetails
	}
	
	/**
	 * Retrieves the details of the user, validating the user exists in CSU's systems.
	 * @param username the login/username of the user.
	 * @return the user's details.
	 */
	def getPersonForUsername(String username) {
		Person person = null
		def url = "/person/" + username
		
		try {
			//def jsonResponse = restService.doCacheableRestRequest(RestService.API_CSUAPPS, url)
			def jsonResponse = restProxyService.doCacheableRequest("person", [username: username])
			
			if (jsonResponse) {
				person = new Person(pidm: jsonResponse.pidm, 
										     id: jsonResponse.id, 
									   username: jsonResponse.username, 
									  firstName: jsonResponse.firstName, 
									   lastName: jsonResponse.lastName, 
								   emailAddress: jsonResponse.emailAddress)
			}
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return person 
	}

	/**
	 * Retrieves the details of the user based on PIDM, validating the user exists in CSU's systems.
	 * @param PIDM of the user.
	 * @return the user's details.
	 */
	def getPersonForPIDM(int pidm) {
		Person person = null
		def url = "/person/byPIDM" + pidm
		try {
			//def jsonResponse = restService.doCacheableRestRequest(RestService.API_CSUAPPS, url)
			def jsonResponse = restProxyService.doCacheableRequest("person/byPIDM", [pidm: pidm])
			
			if (jsonResponse) {
				person = new Person(pidm: jsonResponse.pidm, 
										     id: jsonResponse.id, 
									  firstName: jsonResponse.firstName, 
									   lastName: jsonResponse.lastName, 
								   emailAddress: jsonResponse.emailAddress)
			}
			
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return person 
	}
	
	/**
	 * @param crn
	 * @param termCode
	 * @return
	 */
	def getSubject(String crn, String termCode) {
		def subject = [:]
		def url = "/subject/detail"
		
		try {
			def jsonResponse = restProxyService.doCacheableRequest("subject/detail", [crn: crn, termCode: termCode])
			
			if (jsonResponse) {
				subject = [subjectCode: jsonResponse.subjectCode, 
					          termCode: termCode, 
							    campus: jsonResponse.campus, 
								  mode: jsonResponse.mode, 
								   crn: crn]
			}
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return subject
	}

	/**
	 * @param pidm
	 * @param termCode
	 * @return
	 */
	def getCourseDetails(int pidm, String termCode) {
		def courseDetails = []
		def url = "/misc/course"

		try {
			def jsonResponse = restProxyService.doCacheableRequest("misc/course", [pidm: pidm, termCode: termCode])
			
			if (jsonResponse) {

				jsonResponse.each { course ->
					courseDetails.add([programCode: course.programCode, 
					          	 effectiveTermCode: course.effectiveTermCode, 
							    programName: course.programName])
				}
			}
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return courseDetails
	}

	/**
	 * @param 
	 * @return
	 */
	def getCurrentTerms() {
		def currentTerms = [:]
		def url = "/misc/terms"

		try {
			def jsonResponse = restProxyService.doCacheableRequest("misc/terms",[])
			
			if (jsonResponse) {
				currentTerms = [termCode: jsonResponse.termCode, 
					          	 termStartDate: jsonResponse.termStartDate, 
							    termEndDate: jsonResponse.termStartDate]
			}
		} catch (RestException e) {
			log.warn("Error calling API: ${e.getMessage()} for url: ${url}")
		}
		
		return currentTerms

	}
}
