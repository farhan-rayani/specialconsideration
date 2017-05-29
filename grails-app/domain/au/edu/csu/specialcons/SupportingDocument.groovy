package au.edu.csu.specialcons

import au.edu.csu.utils.DateUtils

/**
 * Domain class for SWRSPDOC - The Special consideration supporting document storage table.
 *
 * @author 		Dewang Shahu <a href="dshahu@csu.edu.au">dshahu@csu.edu.au</a>
 * @since 		20-DEC-2016
 */
class SupportingDocument implements Serializable{

	String guid
	long requestid
	long docid
	byte[] document
	String fileName
	String mimeType
	long mandatory
	long mandatoryOverride
	Date requestDate
	Date activityDate
	String recommendation
	String reason
	
	static mapping = {
		cache false
		version false
		table name: "SWRSPDOC"
		
		id 						 composite:['guid','docid'] 
		guid 					 column: 'SWRSPDOC_GUID', 				sqlType: 'VARCHAR2(50 BYTE)', blank: false
		requestid				 column: 'SWRSPDOC_REQUEST_ID',			sqlType: 'NUMBER(36, 0)', blank: true
		docid 				     column: 'SWRSPDOC_DOCUMENT_ID',	    sqlType: 'NUMBER(2, 0)', blank: false
		document  				 column: 'SWRSPDOC_DOCUMENT', 			sqlType: 'BLOB', blank: false
		fileName  				 column: 'SWRSPDOC_FILE_NAME',          sqlType: 'VARCHAR(50 BYTE)', blank: false
		mimeType 			     column: 'SWRSPDOC_FILE_MIME_TYPE',     sqlType: 'VARCHAR2(100 BYTE)', blank: true
		mandatory 			     column: 'SWRSPDOC_MANDATORY_FLAG',     sqlType: 'NUMBER(1, 0)', blank: false
		mandatoryOverride 	     column: 'SWRSPDOC_MANDATORY_OVERRIDE', sqlType: 'NUMBER(1, 0)', blank: false
		requestDate 			 column: 'SWRSPDOC_REQUEST_DATE', 	    sqlType: 'DATE', blank: true
		activityDate 			 column: 'SWRSPDOC_ACTIVITY_DATE', 	    sqlType: 'DATE', blank: true 
		recommendation 			 column: 'SWRSPDOC_RECOMMENDATION', 	sqlType: 'VARCHAR(1 BYTE)', blank: false
		reason 					 column: 'SWRSPDOC_REASON', 			sqlType: 'VARCHAR(1 BYTE)', blank: false	
	}
	
    static constraints = {
    	guid 					 nullable: false 
		docid 					 nullable: false
		document  				 nullable: false, maxSize: 5242880
		fileName  				 nullable: false, maxSize: 50
		mimeType 			     nullable: true, maxSize: 100
		mandatory 			     nullable: false
		mandatoryOverride		 nullable: false
		requestDate 			 nullable: true
		activityDate 			 nullable: true
		recommendation 			 nullable: true
		reason 			 		 nullable: true
    }
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return "Request: GUID: ${guid}, Request ID: ${requestid}, Docuemnt ID: ${docid}, File Name : ${fileName}, Type : ${mimeType}, Mandatory : ${mandatory}, MandatoryOverride : ${mandatoryOverride},  ActivityDate : ${activityDate}"
	}

}
