package au.edu.csu.utils.taglib

import au.edu.csu.utils.DateUtils

class DateTagLib {
    def dateFormat  = { attrs, body ->
       out <<  DateUtils.formatDate(attrs.date,attrs.format)
    }
}