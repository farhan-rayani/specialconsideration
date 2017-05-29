package au.edu.csu.specialcons

import grails.transaction.Transactional

import org.apache.commons.logging.LogFactory
import org.grails.web.util.WebUtils

@Transactional
class UserService {

	private static final log = LogFactory.getLog(this)
	
    /**
	 * A more centralised location for retrieving the user object from the Request Session.
	 *
	 * @return the current session user object.
	 */
	def getCurrentUser() {
		try {
			def webUtils = WebUtils.retrieveGrailsWebRequest()
			String user = webUtils.getSession().spcUser?.user
			return user
		} catch (Exception e) {
			// No session exists. Return a sytem user.
			log.error("Error accessing session: ${e.getMessage()}")
			return null
		}
	}
}
