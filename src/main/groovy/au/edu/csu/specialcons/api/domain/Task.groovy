package au.edu.csu.specialcons.api.domain

class Task {

	Long taskId
	String guid
	Long studentId
	String studentName
	Date lastActionDate
	String lastActionDateStr
	Date createdDate
	String assignedTo = ""
	String assignedToName = ""
	Boolean isNotify
	
	public static final String ASSIGNED_ME = "Me"
	public static final String ASSIGNED_NOT = "Not Assigned"
	public static final String ASSIGNED_OVERDUE = "Overdue Tasks"
	public static final String ASSIGNED_ALL = "All"
	public static final String ASSIGNED_TO = "Assigned to "
	
	public String toString() {
		return "taskId ${taskId} guid ${guid} studentId ${studentId} studentName ${studentName} lastActionDateStr ${lastActionDateStr} assignedTo ${assignedTo} isNotify ${isNotify} assignedToName ${assignedToName}"
	}
}
