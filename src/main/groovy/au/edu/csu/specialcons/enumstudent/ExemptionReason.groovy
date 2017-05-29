package au.edu.csu.specialcons.enumstudent

public enum ExemptionReason {
	CANT_COMPLETE("I can't complete this residential school due to misadventure or extenuating circumstances"),
	PASSED("I attended the residential school for this subject previously"),
	COMPLETED("I have completed the work to be taught at the residential school previously"),
	
	final String value

	ExemptionReason(String value) { this.value = value }

	String toString() { value }
	String getKey() { name() }
}