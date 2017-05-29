package au.edu.csu.specialcons

class Person {

	String username
	String id
	String lastName
	String firstName
	String emailAddress
	Integer pidm
	
	Person() { }
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return "Person: [username: ${username}, id: ${id}, pidm: ${pidm}, firstName: ${firstName}, lastName: ${lastName}, emailAddress: ${emailAddress}]"
	}
}
