package au.edu.csu.specialcons.enumstaff

public enum RejectionReason {
	N("Not acceptable"),
	C("Cannot open or read document"),

	final String value

	RejectionReason(String value) { this.value = value }

	String toString() { value }
	String getKey() { name() }
}