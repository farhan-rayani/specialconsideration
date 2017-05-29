package au.edu.csu.utils

import grails.util.Environment
import au.edu.csu.specialcons.Constants

class AppUtils {

	/**
	 * Returns the Relative URL for the application root depending on the environment the application
	 * is in.
	 * 
	 * @return the Base application URL.
	 */
	public static String getBaseUrl() {
		if (Environment.isDevelopmentMode()) {
			return "/"
		} else {
			return "/specialcons/"
		}
	}
	
	/**
	 * Returns the Interact URL depending on which environment the application is in.
	 * 
	 * @return the Interact URL.
	 */
	static def getInteractUrl() {
		if (Environment.current == Environment.PRODUCTION) {
			return Constants.SO_URL_PROD
		} else {
			return Constants.SO_URL_DEV
		}
	}
}
