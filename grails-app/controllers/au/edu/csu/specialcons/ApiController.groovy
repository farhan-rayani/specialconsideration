package au.edu.csu.specialcons

import grails.converters.JSON
import groovy.util.logging.Slf4j
import au.edu.csu.specialcons.exceptions.ApplicationException

/**
 * API Controller handles requests for internal rest API calls.
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		16-NOV-2016
 */
@Slf4j
class ApiController {

	EnterpriseDataService enterpriseDataService
	EnterpriseDataFacadeService enterpriseDataFacadeService
	

	
	/**
	 * Returns JSON of subject details for a given CRN and term.
	 */
	def getSubject() {
		log.debug("Controller: ${controllerName}, Action ${actionName}")
		if (!params.crn || !params.termCode) {
			throw new ApplicationException("Required parameter missing from request.")
		}
		
		def subject = enterpriseDataService.getSubject(params.crn, params.termCode)
		
		if (subject) {
			render subject as JSON
		} else {
			response.status = 404
			render([error: 'not found'] as JSON)
		}
	}
}
