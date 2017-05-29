package au.edu.csu.specialcons.utility

import org.apache.commons.logging.LogFactory

/**
 * ViewModel - Utility class for structuring data for a view.
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		24-OCT-2016
 */
class ViewModel {

	private static final log = LogFactory.getLog(this)
	
	Map model
	
	/**
	 * Public constructor creates a new ViewModel object with a new empty model Map container.
	 */
	public ViewModel() {
		model = [:]
	}
	
	/**
	 * Adds an object with a key to the model container.
	 * 
	 * @param _key the key for the new object.
	 * @param _item the object to add.
	 */
	def add(String _key, Object _item) {
		model[(_key)] = _item
	}
	
	/**
	 * Adds an existing map to the map container. If an exception is thrown, the exception is caught 
	 * and a error message is displayed to preserve the original map state.
	 * 
	 * @param map the Map to add.
	 */
	def add(Map map) {
		try {
			model.putAll(map)
		} catch (Exception e) {
			log.error("Unable to add map contents because: ${e.getMessage()}")
		}
	}
	
	/**
	 * Returns the map container.
	 * 
	 * @return the map container.
	 */
	def getModel() {
		return model
	}
	
	/**
	 * Checks the map container for the existence of a given key in the container.
	 *  
	 * @param key the key to check for.
	 * @return the return value from containsKey, i.e. true or false pertaining to whether the key 
	 * was found.
	 */
	def hasKey(String key) {
		return model.containsKey(key)
	}
}
