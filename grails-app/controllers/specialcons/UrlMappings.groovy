package specialcons

class UrlMappings {

    static mappings = {
		/*
		 * Disabled as default.
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        */

		// Forms
		"/application/logout" (controller: "Application", parseRequest: true) {
			action = [GET: "logout"]
		}

		"/application/start" (controller: "Application", parseRequest: true) {
			action = [GET: "index"]
		}
		
		"/application/editSubjects" (controller: "Application", parseRequest: true) {
			action = [GET: "editSubjects"]
		}

		"/application/editReason" (controller: "Application", parseRequest: true) {
			action = [GET: "editReason"]
		}

		"/application/updateReveiwRequest" (controller: "Application", parseRequest: true) {
			action = [GET: "updateReveiwRequest"]
		}

		"/application/reason" (controller: "Application", parseRequest: true) {
			action = [GET: "reason"]
		}

		"/application/reasonResSchoolExemption" (controller: "Application", parseRequest: true) {
			action = [GET: "reasonResSchoolExemption"]
		}
		
		"/application/review" (controller: "Application", parseRequest: true) {
			action = [GET: "review"]
		}

		"/application/showdocument" (controller: "Application", parseRequest: true) {
			action = [GET: "showdocument"]
		}

		"/application/complete" (controller: "Application", parseRequest: true) {
			action = [GET: "complete"]
		}

		"/application" (controller: "Application", parseRequest: true) {
			action = [GET: "index"]
		}
		
		"/application/save" (controller: "Application", parseRequest: true) {
			action = [POST: "save"]
		}
		"/trackRequest/index" (controller: "TrackRequest", parseRequest: true) {
			action = [GET: "index"]
		}
		"/trackRequest/statusRequest" (controller: "TrackRequest", parseRequest: true) {
			action = [GET: "statusRequest"]
		}
		"/application/delete" (controller: "Application", parseRequest: true) {
			action = [POST: "delete"]
		}
		"/application/cancel" (controller: "Application", parseRequest: true) {
			action = [POST: "cancel"]
		}
		//session variable set and get
		"/application/setSessionData" (controller: "Application", parseRequest: true) {
			action = [POST: "setSessionData"]
		}

		"/application/getSessionData" (controller: "Application", parseRequest: true) {
			action = [GET: "getSessionData"]
		}
		// Task Inbox
		// Form
		"/taskInbox/index" (controller: "TaskInbox", parseRequest: true) {
			action = [GET: "awaitingRequest"]
		}
		"/taskInbox/awaitingRequest" (controller: "TaskInbox", parseRequest: true) {
			action = [GET: "awaitingRequest"]
		}
		"/taskInbox/studentHistory" (controller: "TaskInbox", parseRequest: true) {
			action = [GET: "studentHistory"]
		}
		"/taskInbox/searchAssignee" (controller: "TaskInbox", parseRequest: true) {
			action = [GET: "searchAssignee"]
		}
		"/taskInbox/dsoAwaitingTask" (controller: "TaskInbox", parseRequest: true) {
			action = [GET: "dsoAwaitingTask"]
		}
		"/taskInbox/dsoProcessRequest" (controller: "TaskInbox", parseRequest: true) {
			action = [GET: "dsoProcessRequest"]
		}
		"/taskInbox/dsoProcessRequestAction" (controller: "TaskInbox", parseRequest: true) {
			action = [POST: "dsoProcessRequestAction"]
		}
		"/taskInbox/dsoAwaitingTaskAction" (controller: "TaskInbox", parseRequest: true) {
			action = [POST: "dsoAwaitingTaskAction"]
		}
		// Task Inbox
		// API
		"/api/subject" (controller: "Api", parseRequest: true) {
			action = [GET: "getSubject"]
		}
		
		// Defaults
        "/"(view:"/index")
		
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
