package au.edu.csu.specialcons

import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonOutput
import groovy.util.logging.Slf4j
import au.edu.csu.specialcons.exceptions.ApplicationException

@Transactional
@Slf4j
class RestProxyService {
	
	EnterpriseDataFacadeService enterpriseDataFacadeService

    /**
     * @param source
     * @param params
     * @return
     */
    def doCacheableRequest(def source, def params) {
		
		switch(source) {
			case 'person':
				return person(params)
				break
			case 'person/byPIDM':
				return personByPIDM(params)
				break
			case 'subject/eligibleList':
				return subjectEligibleList(params)
				break
			case 'subject/detail':
				return subjectDetail(params)
				break
			case 'misc/campus':
				return miscCampus(params)
				break
			case 'misc/course': 
				return miscCourse(params)
				break
			case 'misc/terms': 
				return miscCurrentTerms()
				break			
			default:
				return null
				break
		}
		
	}
	
	/**
	 * @param params
	 * @return
	 */
	def person(def params) {
		def username = params.username
		if (!username) {
			throw new ApplicationException("Required parameter missing from request.")
		}
		
		def person = enterpriseDataFacadeService.getPersonForUsername(username)
		
		def json = JSON.parse(JsonOutput.toJson(person))
				
		return json
	}
	
	/**
	 * @param params
	 * @return
	 */
	def personByPIDM(def params) {
		def pidm = params.pidm
		if (pidm <= 0) {
			throw new ApplicationException("Required parameter missing from request.")
		}
		
		def person = enterpriseDataFacadeService.getPersonForPIDM(pidm)
		
		def json = JSON.parse(JsonOutput.toJson(person))
				
		return json
	}

	/**
	 * @param params
	 * @return
	 */
	def subjectEligibleList(def params) {
		def pidm = params.pidm
		if (pidm <= 0) {
			throw new ApplicationException("Required parameter missing from request.")
		}
		
		def eligibleSubjects = enterpriseDataFacadeService.getEligibleSubjects(pidm)
		
		def json = JSON.parse(JsonOutput.toJson(eligibleSubjects))
		
		return json
	}
	
	/**
	 * @param params
	 * @return
	 */
	def miscCampus(def params) {
		def campusCode = params.campusCode
		
		if (!campusCode) {
			throw new ApplicationException("Required parameter missing from request.")
		}
		
		def campusDetails = enterpriseDataFacadeService.getCampusDetails(campusCode)
		
		def json = JSON.parse(JsonOutput.toJson(campusDetails))
		
		return json
	}
	
	def subjectDetail(def params) {
		if (!params || !params.crn || !params.termCode) {
			throw new ApplicationException("Required parameter missing from request.")
		}
		
		def subjectDetail = enterpriseDataFacadeService.getSubjectDetail(params.crn, params.termCode)
		
		def json = JSON.parse(JsonOutput.toJson(subjectDetail))
		
		return json
	}

	/**
	 * @param params
	 * @return
	 */
	def miscCourse(def params) {
		def pidm = params.pidm
		if (!params || pidm <= 0 || !params.termCode) {
			throw new ApplicationException("Required parameter missing from request.")
		}

		def courseDetails = enterpriseDataFacadeService.getCourseDetails(pidm, params.termCode)

		def json = JSON.parse(JsonOutput.toJson(courseDetails))

		return json
	}

	/**
	 * @param params
	 * @return
	 */
	def miscCurrentTerms() {
		
		def currentTerms = enterpriseDataFacadeService.getCurrentTerms()
		
		def json = JSON.parse(JsonOutput.toJson(currentTerms))
		
		return json
	}
}
