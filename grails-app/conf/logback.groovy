import grails.util.BuildSettings
import grails.util.Environment


def logPattern = "%d{HH:mm:ss} [%thread] %-5level %logger{16} - %msg%n"

appender('STDOUT', ConsoleAppender) {
    encoder(PatternLayoutEncoder) {
        pattern = "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{16} - %msg%n"
    }
}

root(ERROR, ['STDOUT'])

def targetDir = BuildSettings.TARGET_DIR

if (Environment.isDevelopmentMode() && targetDir) {
	// local development config
	// stacktrace log
	logger("au.edu.csu", DEBUG)
	appender("FULL_STACKTRACE", RollingFileAppender) {
		file = "${targetDir}/spcon-stacktrace.log"
		append = true
		encoder(PatternLayoutEncoder) {
			pattern = logPattern //"%level %logger - %msg%n"
		}
		
		rollingPolicy(TimeBasedRollingPolicy) {
			fileNamePattern = "${targetDir}/spcon-stacktrace.%d{yyyy-MM-dd}.log"
			maxHistory = 30
		}
	}
	logger("StackTrace", ERROR, ['FULL_STACKTRACE'], false)
	// spcon log
	appender("FILE", RollingFileAppender) {
		file = "${targetDir}/spcon.log"
		append = true
		encoder(PatternLayoutEncoder) {
			pattern = logPattern //"%level %logger - %msg%n"
		}
		
		rollingPolicy(TimeBasedRollingPolicy) {
			fileNamePattern = "${targetDir}/spcon.%d{yyyy-MM-dd}.log"
			maxHistory = 30
		}
	}
	logger("au.edu.csu", DEBUG, ['FILE'], true)
	//logger("org.hibernate.SQL", DEBUG, ['FILE'], true)
}

if (Environment.current != Environment.DEVELOPMENT && Environment.current != Environment.TEST) {
	// configure the devel, qa and prod tomcat server logs
	// stacktrace log
	appender("FULL_STACKTRACE", RollingFileAppender) {
		file = "/var/log/tomcat/spcon-stacktrace.log"
		append = true
		encoder(PatternLayoutEncoder) {
			pattern = logPattern //"%level %logger - %msg%n"
		}
		
		rollingPolicy(TimeBasedRollingPolicy) {
			fileNamePattern = "/var/log/tomcat/spcon-stacktrace.%d{yyyy-MM-dd}.log"
			maxHistory = 30
		}
	}
	logger("StackTrace", ERROR, ['FULL_STACKTRACE'], false)
	// spcon log
	appender("FILE", RollingFileAppender) {
		file = "/var/log/tomcat/spcon.log"
		append = true
		encoder(PatternLayoutEncoder) {
			pattern = logPattern //"%level %logger - %msg%n"
		}
		
		rollingPolicy(TimeBasedRollingPolicy) {
			fileNamePattern = "/var/log/tomcat/spcon.%d{yyyy-MM-dd}.log"
			maxHistory = 30
		}
	}
	logger("au.edu.csu", DEBUG, ['FILE'], false)
	//logger("org.hibernate.SQL", DEBUG, ['FILE'], true)
}

if (Environment.current == Environment.PRODUCTION) {
	// configure the devel, qa and prod tomcat server logs
	// stacktrace log
	appender("FULL_STACKTRACE", RollingFileAppender) {
		file = "/var/log/tomcat/spcon-stacktrace.log"
		append = true
		encoder(PatternLayoutEncoder) {
			pattern = logPattern //"%level %logger - %msg%n"
		}
		
		rollingPolicy(TimeBasedRollingPolicy) {
			fileNamePattern = "/var/log/tomcat/spcon-stacktrace.%d{yyyy-MM-dd}.log"
			maxHistory = 30
		}
	}
	logger("StackTrace", ERROR, ['FULL_STACKTRACE'], false)
	// spcon log
	appender("FILE", RollingFileAppender) {
		file = "/var/log/tomcat/spcon.log"
		append = true
		encoder(PatternLayoutEncoder) {
			pattern = logPattern //"%level %logger - %msg%n"
		}
		
		rollingPolicy(TimeBasedRollingPolicy) {
			fileNamePattern = "/var/log/tomcat/spcon.%d{yyyy-MM-dd}.log"
			maxHistory = 30
		}
	}
	logger("au.edu.csu", INFO, ['FILE'], false)
}
