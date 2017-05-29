package specialcons

import grails.boot.GrailsApp
import grails.boot.config.GrailsAutoConfiguration
import specialcons.Application;

class Application extends GrailsAutoConfiguration {
    static void main(String[] args) {
        GrailsApp.run(Application, args)
    }
}