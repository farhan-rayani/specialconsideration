package au.edu.csu.specialcons

import grails.core.GrailsApplication
import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.transaction.Transactional
import groovy.util.logging.Log

import org.apache.commons.logging.LogFactory

import au.edu.csu.specialcons.exceptions.RestException

@Transactional
class RestService {

	private static final log = LogFactory.getLog(this)
	
	private static final int API_CSUAPPS = 1
	private static final int API_BPMBUSINESS = 2
	private static final int API_TASK = 3
	
	GrailsApplication grailsApplication
	
	/**
	 * Performs a http rest request and returns the json object.
	 * @param requestUrl
	 * @return
	 * @throws RestException
	 */
	def doRestRequest(String requestUrl) throws RestException {
		// the doCacheableRestRequest method is not cached when called from the same service
		return doCacheableRestRequest(requestUrl)
	}

	/**
	 * Performs a http rest request and returns the json object. The result is cached.
	 * @param requestUrl
	 * @return
	 * @throws RestException
	 */
	def doCacheableRestRequest(final int api, String requestUrl) throws RestException {
		def responseJson = null

		RestBuilder restBuilder = new RestBuilder()
		RestResponse resp = null
		def url = null
		def username = null
		def password = null
		def key = null

		switch(api) {
			case API_CSUAPPS:
				url = grailsApplication.config.csuapi.url + requestUrl
				if (grailsApplication.config.csuapi.user && grailsApplication.config.csuapi.password) {
					username = grailsApplication.config.csuapi.user
					password = grailsApplication.config.csuapi.password
				}
				if (grailsApplication.config.csuapi.key) {
					key = grailsApplication.config.csuapi.key
				}
				break
			case API_BPMBUSINESS:
				url = grailsApplication.config.csubpm.url + requestUrl
				if (grailsApplication.config.csubpm.user && grailsApplication.config.csubpm.password) {
					username = grailsApplication.config.csubpm.user
					password = grailsApplication.config.csubpm.password
				}
				if (grailsApplication.config.csubpm.key) {
					key = grailsApplication.config.csubpm.key
				}
				break
				
			case API_TASK:
				url = grailsApplication.config.csutask.url + requestUrl
				if (grailsApplication.config.csutask.user && grailsApplication.config.csutask.password) {
					username = grailsApplication.config.csutask.user
					password = grailsApplication.config.csutask.password
				}
				if (grailsApplication.config.csutask.key) {
					key = grailsApplication.config.csutask.key
				}
				break
		}
		
		log.debug("Url: ${url}") 

		// Do HTTP request
		try {
			resp = restBuilder.get(url) {
				// set auth if credentials are configured
				if (username && password) {
					auth username, password
				}
				//if (restKey) {
					//header("Authorization", "Basic d2VidXNlcjp3ZWJ1c2Vy")
				//}
				contentType("application/json")
			}
			//log.debug("Resp: ${resp.text}")
			
		} catch (Exception e) {
			def error = "A HTTP Request error occurred for ${url}"
			log.error(error, e)
			throw new RestException(error, e)
		}

		if (resp.getStatus() == 200) {
			responseJson = resp.json
		} else {
			def error = 'REST request failed for url: ' + url + '. HTTP status: ' + resp.getStatus() + '.'
			log.error(error)
			throw new RestException(error)
		}

		return responseJson
	}
	
	/**
	 * @param endpointUrl
	 * @param data
	 * @return
	 * @throws RestException
	 */
	def doRestSubmit(final int api, String endpointUrl, def data) throws RestException {
		def responseJson = null
		
		RestBuilder restBuilder = new RestBuilder()
		RestResponse resp = null
		def url = null
		def username = null
		def password = null
		def key = null

		switch(api) {
			case API_CSUAPPS:
				url = grailsApplication.config.csuapi.url + requestUrl
				if (grailsApplication.config.csuapi.user && grailsApplication.config.csuapi.password) {
					username = grailsApplication.config.csuapi.user
					password = grailsApplication.config.csuapi.password
				}
				if (grailsApplication.config.csuapi.key) {
					key = grailsApplication.config.csuapi.key
				}
				break
			case API_BPMBUSINESS:
				url = grailsApplication.config.csubpm.url + requestUrl
				if (grailsApplication.config.csubpm.user && grailsApplication.config.csubpm.password) {
					username = grailsApplication.config.csubpm.user
					password = grailsApplication.config.csubpm.password
				}
				if (grailsApplication.config.csubpm.key) {
					key = grailsApplication.config.csubpm.key
				}
				break
		}
		
		try {
			resp = restBuilder.put(url) {
				if (username && password) {
					auth username, password
				}
				if (restKey) {
					header("Authorization", "Bearer " + restKey)
				}
				contentType("application/json")
				json data
			}
		} catch (Exception e) {
			def error = 'A HTTP Request error occurred'
			log.error(error, e)
			throw new RestException(error, e)
		}
		
		if (resp.getStatus() == 200) {
			responseJson = resp.json
		} else {
			def error = 'REST submit failed for url: ' + url + '. HTTP status: ' + resp.getStatus() + '.'
			log.error(error)
			throw new RestException(error)
		}

		return responseJson
	}
	
	
	/**
	 * @param endpointUrl
	 * @param data
	 * @return
	 * @throws RestException
	 */
	def doRestPost(final int api, String endpointUrl, def data) throws RestException {
		def responseJson = null
		
		RestBuilder restBuilder = new RestBuilder()
		RestResponse resp = null
		def url = null
		def username = null
		def password = null
		def restKey = null

		switch(api) {
			case API_TASK:
			url = grailsApplication.config.csutask.url + endpointUrl
			if (grailsApplication.config.csutask.user && grailsApplication.config.csutask.password) {
				username = grailsApplication.config.csutask.user
				password = grailsApplication.config.csutask.password
			}
			if (grailsApplication.config.csutask.key) {
				key = grailsApplication.config.csutask.key
			}
			break
		}
		
		try {
			resp = restBuilder.post(url) {
				if (username && password) {
					auth username, password
				}
				if (restKey) {
					header("Authorization", "Bearer " + restKey)
				}
				accept("application/json")
				contentType("application/json")
				json data
			}
		} catch (Exception e) {
			def error = 'A HTTP Request error occurred'
			log.error(error, e)
			throw new RestException(error, e)
		}
		
		if (resp.getStatus() == 200) {
			responseJson = resp.json
		} else {
			
			def error = 'REST submit failed for url: ' + url + '. HTTP status: ' + resp.getStatus() +resp.json
			
			log.error(error)
			throw new RestException(error)
		}

		return responseJson
	}
	
	/**
	 * Clear rest cache
	 * @return
	 */
	def cacheEvict() {
	   log.warn 'Evict spcon-cache'
	}
}
