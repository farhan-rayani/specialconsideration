package au.edu.csu.specialcons.security

import grails.transaction.Transactional
import grails.util.Environment

import org.grails.web.util.WebUtils

import au.edu.csu.specialcons.EnterpriseDataService
import au.edu.csu.specialcons.Person

@Transactional
class SecurityService {

	EnterpriseDataService enterpriseDataService
	
    /**
	 * Return the remote user, unless the remote user is not provided for the development environment
	 * @param remoteUser
	 * @param session
	 * @return
	 */
	def getRemoteUser(remoteUser, session) {
		if (!remoteUser && Environment.current == Environment.DEVELOPMENT) {
			// hardcode user for development environment
			remoteUser = 'mkaur19' //'swilbu01' // Student with subjects
		}

		// Need to interrogate session? Do it here.

		return remoteUser
	}
	
	/**
	 * @return
	 */
	def getSession() {
		def session = null
		try {
			def webUtils = WebUtils.retrieveGrailsWebRequest()
			session = webUtils.getSession()
		} catch (Exception e) {
		}
		return session
	}
	
	/**
	 * Check if the remote user has a valid account
	 * @param remoteUser
	 * @return
	 */
	boolean isValidUser(remoteUser) {
		def currentUser = getRemoteUser(remoteUser, null)
		Person currentPerson = enterpriseDataService.getPersonForUsername(currentUser)
		if (currentPerson) {
			return true
		}
		return false
	}
}
