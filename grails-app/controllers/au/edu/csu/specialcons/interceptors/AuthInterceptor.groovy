package au.edu.csu.specialcons.interceptors

import au.edu.csu.specialcons.security.SecurityService;
import groovy.util.logging.Slf4j

/**
 * Auth Interceptor validates the user on every controller request.
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		14-NOV-2016
 */
@Slf4j
class AuthInterceptor {
	
	SecurityService securityService

	AuthInterceptor() {
		matchAll().excludes(controller: 'api')
				  //.excludes(controller: 'application')
	}
	
    boolean before() {
		if (!securityService.isValidUser(request.getRemoteUser())) {
			log.warn('User [' + securityService.getRemoteUser(request.getRemoteUser(), null) + '] denied access to application')
			//render(view: '/applicationAccessDenied')
			return false
		}
		true 
	}

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
