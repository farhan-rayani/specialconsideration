package au.edu.csu.utils


import java.text.DateFormat
import java.text.ParseException
import java.text.SimpleDateFormat
import java.time.Duration
import java.time.Instant
import java.time.LocalDate;

import org.apache.commons.logging.LogFactory

import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;
/**
 * A utility class containing date methods that make mundane tasks less mundane.
 *
 * @author 		Chris Dunstall <a href="mailto:cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		11-MAR-2016
 */
class DateUtils {

	private static final log = LogFactory.getLog(this)
	
	public static final int NOT_OVERLAPPING = 0;
	public static final int IDENTICAL = 1;
	public static final int FIRST_ENCLOSED = 2;
	public static final int SECOND_ENCLOSED = 3;
	public static final int FIRST_ACTIVE_FIRST = 4;
	public static final int SECOND_ACTIVE_FIRST = 5;
	
	/**
	 * Returns the current time in milliseconds since Epoch.
	 *
	 * @return the current time in milliseconds
	 */
	static def currentTime() {
		return System.currentTimeMillis()
	}
	
	/**
	 * Returns the current date with the current time in milliseconds.
	 *
	 * @return the current date.
	 */
	static def sysdate() {
		return new Date(System.currentTimeMillis())
	}
	
	/**
	 * @return
	 */
	static def getCurrentYear() {
		int year = Calendar.getInstance().get(Calendar.YEAR)
		return year
	}
	
	/**
	 * Formats a date with a specific given format. If any exception is caught while attempting the
	 * format, an empty string is returned.
	 *
	 * @param date the date to format.
	 * @param format the specified format to use.
	 *
	 * @return the formated date as a String.
	 * @see au.edu.csu.salplus.Constants
	 */
	static def formatDate(Date date, String format) {
		try {
			if (date == null) {
				return ''
			}
			DateFormat dt = new SimpleDateFormat(format)
			return dt.format(date)
		} catch (ParseException e) {
			return ''
		}
	}
	
	static String formatDateStr(String dateStr, String fromFormat , String toFormat) {
			Date date = parseDate(dateStr,fromFormat)
			SimpleDateFormat sdt = new SimpleDateFormat(toFormat)
			String toDateStr = sdt.format(date)
			return toDateStr
	}
	
	/**
	 * Formats a string for a given format into a Date object. 
	 * @param date
	 * @param format
	 * @return
	 */
	static def parseDate(String date, String format) {
		try {
			if (!StringUtils.isEmpty(date) && !StringUtils.isEmpty(format)) {
				DateFormat df = new SimpleDateFormat(format, Locale.ENGLISH)
				Date result = df.parse(date)
				return result
			} else {
				
				return null
			}
		} catch (Exception e) {
			log.error("Unable to parse String (${date}) into Date object using format [${format}].", e)
			return null
		}
	}
	
	/**
	 * Checks if the first date is before the second date and returns the result. 
	 * If one of the dates is null, the assumption is that the null date represents 
	 * the end of time (the future).
	 * @param firstDate the first Date object
	 * @param secondDate the second Date object
	 * @return true if the first date comes before the second date.
	 */
	static def isBefore(Date firstDate, Date secondDate) {
		//log.debug("firstDate: ${firstDate} ${firstDate?.getTime()}, secondDate: ${secondDate} ${secondDate?.getTime()}")
		
		if (firstDate == null && secondDate != null) {
			return false
		} else if (firstDate != null && secondDate == null) {
			return true
		} else if (firstDate == null && secondDate == null) {
			return true
		} else {
			return firstDate?.getTime() < secondDate?.getTime()
		}
	}
	
	/**
	 * Checks if the two date sets (of effectiveFrom and effectiveTwo) are overlapping and returns a simple true or false.
	 *
	 * @param first the first date range, an array consisting of a from and to date.
	 * @param second the second date range, an array consisting of a from and to date.
	 * @return true if the date ranges overlap.
	 */
	public static boolean isOverlapping(List first, List second) {
		/*
		 * 1. true
		 *    |----------------|
		 *               |----------------|
		 *
		 * 2. true
		 *               |----------------|
		 *    |----------------|
		 *
		 * 3. false
		 *    |----------------|
		 *                          |------------------|
		 *
		 * 4. false
		 *                          |------------------|
		 *    |----------------|
		 *
		 * 5. true
		 *                     |----------------|
		 *    |----------------|
		 *
		 * 6. true
		 *    |----------------|
		 *        |--------|
		 *
		 * 7. true
		 *    |----------------|
		 *    |----------------|
		 */
		
		if ((second[0] > checkForNullDate(first[1])) || (first[0] > checkForNullDate(second[1]))) return false
		return true
	}
	
	/**
	 * Checks whether two date ranges are identical and returns a simple true or false.
	 *
	 * @param first the first date range, an array consisting of a from and to date.
	 * @param second the second date range, an array consisting of a from and to date.
	 * @return true if the date ranges are identical.
	 */
	public static boolean isEqualDateRange(List first, List second) {
		if (first[0] == second[0] && checkForNullDate(first[1]) == checkForNullDate(second[1]))
			return true
		return false
	}
	
	/**
	 * <p>Compares two dates, much like isOverlapping and isEqualDateRange, but returns a constant value indicating how the two date ranges overlap.</p>
	 * <p>
	 *  <ul>
	 *   <li>IDENTICAL is returned if DateUtils.isEqualDateRange() returns true</li>
	 *   <li>FIRST_ENCLOSED or SECOND_ENCLOSED is returned if the first or second date range is enclosed by the other (respectively).</li>
	 *   <li>FIRST_ACTIVE_FIRST is returned if the first date range is active first; and likewise with</li>
	 *   <li>SECOND_ACTIVE_FIRST is returned if the second date range is active first.</li>
	 *  </ul>
	 * </p>
	 *
	 * @param first the first date range, an array consisting of a from and to date.
	 * @param second the second date range, an array consisting of a from and to date.
	 * @return how the two date ranges overlap. Returns DateUtils.NOT_OVERLAPPING if they do not.
	 */
	public static int compareDates(List first, List second) {
		if (DateUtils.isOverlapping(first, second)) {
			if (DateUtils.isEqualDateRange(first, second)) {
				return DateUtils.IDENTICAL;
			} else {
				if (first[0] <= second[0]) {
					if (checkForNullDate(second[1]) < checkForNullDate(first[1])) {
						return DateUtils.SECOND_ENCLOSED;
					} else {
						return DateUtils.FIRST_ACTIVE_FIRST;
					}
				}
				if (second[0] <= first[0]) {
					if (checkForNullDate(first[1]) < checkForNullDate(second[1])) {
						return DateUtils.FIRST_ENCLOSED;
					} else {
						return DateUtils.SECOND_ACTIVE_FIRST;
					}
				}
			}
		}

		return DateUtils.NOT_OVERLAPPING;
	}
	
	/**
	 * When dealing with effectiveTo dates, we need to check if we have a null date object.
	 * If it's null, return a date a LONG way into the future.
	 *
	 * If this program is still being used in December 2199, please put a gold star on my tombstone.
	 *
	 * @param chkDate
	 * @return
	 */
	public static Date checkForNullDate(Date chkDate) {
		if (chkDate == null) {
			def endOfTime = getDate(2199, Calendar.DECEMBER, 31)
			return new Date(endOfTime.getTime()).clearTime()
		} else {
			return chkDate
		}
	}
	
	/**
	 * Returns a new {@link Date} with the specified Year, Month and Day.
	 *
	 * @param year the specified year.
	 * @param month the specified month.
	 * @param day the specified day.
	 *
	 * @return the new {@link Date} object.
	 */
	public static Date getDate(int year, int month, int day) {
		def dateObj = Calendar.instance
		dateObj.set year, month, day
		return dateObj.getTime().clearTime()
	}
	
	/**
	 * Returns a new business day (Mon-Fri) after the number of days past the supplied date and days.
	 *
	 * @param Date.
	 * @param number of working days to add.
	 *
	 * @return the new date in a simple date format string.
	 */
	public static String addWorkDays(String date, long workdays) {
	    if (workdays < 1) {
	        return date;
	    }

	    LocalDate calculatedDate = getLocalDate(date);
	    LocalDate dt = getLocalDate(date);
	    int addedDays = 0;
	    
	    while (addedDays < workdays) {
	        calculatedDate = calculatedDate.plusDays(1);
	        if (!(calculatedDate.getDayOfWeek() == DayOfWeek.SATURDAY ||
	              calculatedDate.getDayOfWeek() == DayOfWeek.SUNDAY)) {
	            ++addedDays; 
	        }
    	}
    	return formatDateStr(calculatedDate.toString(), "yyyy-MM-dd", "dd/MM/yyyy");
	}

	public static getLocalDate(String date)
	{
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
		LocalDate localDate = LocalDate.parse(date, formatter);
		return localDate;
	}
	
	public static String convertApiDate(String dateStr){
		
		String[] dateArr = dateStr.split(" ");
		dateStr = dateArr[1] +" "+ dateArr[2] + " "+dateArr[5] + " "+dateArr[3]
		return dateStr
	}
}
