package au.edu.csu.specialcons

import groovy.util.logging.Slf4j;

@Slf4j
class Constants {

	//Reason Types
	public static final String REASON_TYPE_MED_ABI = "ABI" 
	public static final String REASON_TYPE_MED_EI = "EI"
	public static final String REASON_TYPE_FPR = "FPR"
	public static final String REASON_TYPE_ER = "ER"
	public static final String REASON_TYPE_AI = "AI"
	public static final String REASON_TYPE_RC = "RC"
	public static final String REASON_TYPE_MC = "MC"
	public static final String REASON_TYPE_LC = "LC"
	public static final String REASON_TYPE_OE = "OE"
	public static final String REASON_TYPE_CI = "CI"
	
	// Request Types
	public static final String REQUEST_TYPE_GP = "GP"
	public static final String REQUEST_TYPE_SX = "SX"
	public static final String REQUEST_TYPE_AW = "AW"
	public static final String REQUEST_TYPE_EX_P = "EXP"
	public static final String REQUEST_TYPE_EX_R = "EXR"
	public static final String REQUEST_TYPE_EX_C= "EXC"
	
	// Subject Modes
	public static final String MODE_INTERNAL = "I"
	public static final String MODE_INTERNAL_DISPLAY = "On Campus"
	public static final String MODE_DISTANCE = "D"
	public static final String MODE_DISTANCE_DISPLAY = "Online"
	
	//Reason Types
	public static final int STATUS_NOT_SUBMITTED = 0
	public static final int STATUS_SUBMITTED = 1
	public static final int STATUS_PROCESSING = 2
	public static final int STATUS_ACTION_REQUIRED = 10
	public static final int STATUS_ACTION_PROVIDED = 11
	public static final int STATUS_EXPIRED = 20
	public static final int STATUS_CANCELLED = 21
	public static final int STATUS_APPROVED = 22
	public static final int STATUS_DECLINED = 23
	public static final int STATUS_VARIED = 24

	//subject offering url
	public static final String SO_URL_PROD = "http://interact.csu.edu.au/sakai-msi-tool/content/bbv.html?subjectView=true&siteId="
	public static final String SO_URL_DEV = "http://interactdevel.csu.edu.au/sakai-msi-tool/content/bbv.html?subjectView=true&siteId="
	
}
