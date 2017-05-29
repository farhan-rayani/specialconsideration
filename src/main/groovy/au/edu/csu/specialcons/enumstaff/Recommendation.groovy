package au.edu.csu.specialcons.enumstaff

public enum Recommendation {
	A("Accept Selected Document"),
	R("Reject Documents"),

	final String value

	Recommendation(String value) { this.value = value }

	String toString() { value }
	String getKey() { name() }
}