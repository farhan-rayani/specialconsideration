package au.edu.csu.utils


import static java.util.UUID.randomUUID

import org.apache.commons.logging.LogFactory

import au.edu.csu.specialcons.exceptions.ApplicationException

/**
 * A utility class containing date methods that make mundane tasks less mundane.
 *
 * @author 		Chris Dunstall <a href="mailto:cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		11-MAR-2016
 */
class StringUtils {

	private static final log = LogFactory.getLog(this)
	
	
	/**
	 * Checks a string variable if it's null or a no-length String and returns true if either.
	 *
	 * @param varCheck the string to check.
	 * @return true if the variable is null or a no-length string.
	 */
	static boolean isEmpty(String varCheck) {
		if (varCheck == null) {
			return true
		}
		
		if (varCheck.equals("")) {
			return true
		}
		
		return false
	}
	
	/**
	 * Checks a String varialbe for null. If the variable is null, an empty String is returned, else
	 * the variable is returned.
	 *
	 * @param var the variable to check.
	 *
	 * @return the variable if not null, or an empty String if it is.
	 */
	static String nullToEmptyString(String var) {
		if (var == null) {
			return ""
		}
		return var
	}
	
	/**
	 * If the String var is an integer number, the int value is returned, otherwise 0.
	 * @param var the integer as a String.
	 * @return the int value of the integer.
	 */
	static int intValue(String var) {
		if (isEmpty(var)) {
			return 0
		}
		try {
			return Integer.valueOf(var).intValue()
		} catch (NumberFormatException e) {
			return 0
		}
	}
	
	/**
	 * Generates a 32 character UUID.
	 * @return
	 */
	static String generateUUID() {
		return (randomUUID() as String).toUpperCase()
	}
	
	/**
	 * Splits a subject offering string in the format 'subjectcode_termCode_campusCode_mode' into a map containing each element.
	 * 
	 * @param subjectOffering the subject offering to split.
	 * @return the map containing the elements of the subject offering.
	 */
	static def splitSubjectOffering(String subjectOffering) {
		if (isEmpty(subjectOffering)) {
			return [:]
		}
		def enrolment = [:]
		
		def splitTask = subjectOffering.split("_")
		enrolment.subjectCode = (splitTask[0] != null) ? splitTask[0] : ""
		enrolment.termCode =    (splitTask[1] != null) ? splitTask[1] : ""
		enrolment.campusCode =  (splitTask[2] != null) ? splitTask[2] : ""
		enrolment.mode =        (splitTask[3] != null) ? splitTask[3] : ""
		
		if (enrolment.containsValue(null)) {
			throw new ApplicationException("Missing required parameter")
		}
		
		return enrolment
	}
}
