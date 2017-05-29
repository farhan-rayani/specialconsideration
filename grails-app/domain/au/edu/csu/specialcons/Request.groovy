package au.edu.csu.specialcons

/**
 * Domain class for SWRSPEC - The Special consideration request table.
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		07-NOV-2016
 */
class Request {

	long id
	String guid
	int pidm
	RequestStatus statusId
	String requestType
	String requestReason
	String reasonText
	Integer counselling
	String crn
	String session
	String assessmentItem
	String processId
	Date extensionDate
	Integer hasProvidedDocumentation
	Integer hasOptionalDocumentation
	Integer hasSubmitted
	Date requestDate
	Date activityDate
	Date statusDate
	Date createdDate
	String extAcceptFlag
	Date  extAltDate
	String extAltReason 
	
	static mapping = {
		cache false
		version false
		table name: "SWRSPEC"
		
		id 						 column: 'SWRSPEC_REQUEST_ID', generator:'sequence', params:[sequence:'SWRSPECREQUESTID_SEQ']
		guid 					 column: 'SWRSPEC_GUID', 			   sqlType: 'VARCHAR2(50 BYTE)', blank: false
		pidm  					 column: 'SWRSPEC_PIDM', 			   sqlType: 'NUMBER(8,0)', blank: false
		statusId  				 column: 'SWRSPEC_STATUS_ID',          sqlType: 'NUMBER(3,0)', blank: false
		requestType 			 column: 'SWRSPEC_REQUEST_TYPE',       sqlType: 'VARCHAR2(10 BYTE)', blank: false
		requestReason 			 column: 'SWRSPEC_REASON_SELECTED',    sqlType: 'VARCHAR2(255 BYTE)', blank: true
		reasonText 				 column: 'SWRSPEC_REASON_TEXT',        sqlType: 'VARCHAR2(500 BYTE)', blank: true
		crn 					 column: 'SWRSPEC_SUBJECT_CRN', 	   sqlType: 'VARCHAR2(6 BYTE)', blank: false
		session 				 column: 'SWRSPEC_SUBJECT_SESSION',    sqlType: 'VARCHAR2(7 BYTE)', blank: false
		assessmentItem 			 column: 'SWRSPEC_ASSESSMENT_ITEM',    sqlType: 'VARCHAR2(255 BYTE)', blank: true
		processId 				 column: 'SWRSPEC_PROCESS_ID', 		   sqlType: 'VARCHAR2(255 BYTE)', blank: true
		extensionDate 			 column: 'SWRSPEC_EXTENSION_DATE', 	   sqlType: 'DATE', blank: true
		hasProvidedDocumentation column: 'SWRSPEC_DOCUMENTATION_FLAG', sqlType: 'NUMBER(1,0)', blank: false
		hasOptionalDocumentation column: 'SWRSPEC_DOCUMENTATION_OPTIONAL', sqlType: 'NUMBER(1,0)', blank: false
		hasSubmitted 			 column: 'SWRSPEC_SUBMITTED_FLAG',     sqlType: 'NUMBER(1,0)', blank: false
		requestDate 			 column: 'SWRSPEC_REQUEST_DATE', 	   sqlType: 'DATE', blank: true
		activityDate 			 column: 'SWRSPEC_ACTIVITY_DATE', 	   sqlType: 'DATE', blank: true
		counselling				 column: 'SWRSPEC_COUNSELLING_FLAG',   sqlType: 'NUMBER(1,0)', blank: true 
		statusDate 			 	 column: 'SWRSPEC_STATUS_DATE', 	   sqlType: 'DATE', blank: true
		createdDate 			 column: 'SWRSPEC_CREATED_DATE', 	   sqlType: 'DATE', blank: true	
		extAcceptFlag			 column: 'SWRSPEC_EXT_ACCEPT_FLAG',	   sqlType: 'VARCHAR2(1)', blank: true
		extAltDate				 column: 'SWRSPEC_EXT_ALT_DATE',	   sqlType: 'DATE', blank: true
		extAltReason			 column: 'SWRSPEC_EXT_ALT_REASON',	   sqlType: 'VARCHAR2(500 BYTE)', blank: true

	}
	
    static constraints = {
		guid 					 nullable: false, maxSize: 50
		pidm  					 nullable: false
		statusId  				 nullable: false
		requestType 			 nullable: false, maxSize: 10
		requestReason 			 nullable: true, maxSize: 255
		reasonText 				 nullable: true, maxSize: 500
		crn 					 nullable: false, maxSize: 6
		session 				 nullable: false, maxSize: 7
		assessmentItem 			 nullable: true, maxSize: 255
		processId 				 nullable: true, maxSize: 255
		extensionDate 			 nullable: true
		hasProvidedDocumentation nullable: false
		hasOptionalDocumentation nullable: false
		hasSubmitted 			 nullable: false
		requestDate 			 nullable: true
		activityDate 			 nullable: true
		counselling 			 nullable: true		
		statusDate 				 nullable: true 
		createdDate 			 nullable: true 
		extAcceptFlag 			 nullable: true 
		extAltDate 				 nullable: true
		extAltReason 			 nullable: true
    }
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return "Request: id: ${id}, GUID: ${guid}, Subject CRN: ${crn}, Session: ${session}, Type: ${requestType}, ActivityDate: ${activityDate}, submitted: ${hasSubmitted}, statusId: ${statusId}, statusDate: ${statusDate}, createdDate: ${createdDate}, extAcceptFlag ${extAcceptFlag}, extAltDate ${extAltDate}, extAltReason ${extAltReason}"
	}
}
