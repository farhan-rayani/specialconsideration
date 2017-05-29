package au.edu.csu.specialcons

/**
 * Domain class for STVSCST - The Special consideration request status validation table
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		23-NOV-2016
 */
class RequestStatus {

	Integer id
	String title
	String detail
	
		static mapping = {
		cache false
		version false
		table name: "STVSCST"
		
		id 						 column: 'STVSCST_CODE', generator:'assigned'
		title 					 column: 'STVSCST_TITLE',  sqlType: 'VARCHAR2(255 BYTE)', blank: false
		detail 					 column: 'STVSCST_DETAIL', sqlType: 'VARCHAR2(255 BYTE)', blank: false
	}
	
    static constraints = {
		title  nullable: false, maxSize: 255
		detail nullable: false, maxSize: 255
    }
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return "Status: title: ${title}, details: ${detail}, code: ${id}"
	}

	public String toTitle() {
		return "${title}"
	}

	public String toId() {
		return "${id}"
	}
}
