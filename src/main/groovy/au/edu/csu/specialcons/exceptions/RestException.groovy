package au.edu.csu.specialcons.exceptions

class RestException extends Exception {
	
	public RestException() {}
	
	public RestException(String message) {
		super(message)
	}
	
	public RestException(String message, Throwable cause) {
		super(message, cause)
	}
	
}
