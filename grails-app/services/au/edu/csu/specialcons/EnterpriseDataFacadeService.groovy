package au.edu.csu.specialcons

import grails.transaction.Transactional
import groovy.sql.Sql
import groovy.util.logging.Slf4j;

/**
 * Enterprise Data Facade Service responsible for all enterprise data interaction for the Special Consideration Application.
 * This service is a facade of enterprise data retreival as this data should be obtained via API.
 *
 * @author 		Chris Dunstall <a href="cdunstall@csu.edu.au">cdunstall@csu.edu.au</a>
 * @since 		14-NOV-2016
 */
@Transactional
@Slf4j
class EnterpriseDataFacadeService {

	def dataSource
	
	/**
	 * @param username
	 * @return
	 */
	def getPersonForUsername(String username) {
		def sql
		def person = [:]

		try {
			sql = new Sql(dataSource)
			def query = """\
				SELECT
				  pidm,
				  login_id,
				  user_type,
				  spriden_id,
				  spriden_first_name,
				  spriden_last_name,
				  goremal_email_address
				FROM
				  www_access_nopass
				JOIN spriden
				ON
				  spriden_pidm          = pidm
				AND spriden_change_ind IS NULL
				AND spriden_entity_ind  = 'P'
				JOIN goremal
				ON
				  goremal_pidm            = pidm
				AND goremal_status_ind    = 'A'
				AND goremal_preferred_ind = 'Y'
				WHERE
				  login_id = :username """.stripIndent()

			def result = sql.eachRow(query, [username: username]) { row ->
				person = [pidm: ((BigDecimal) row.pidm).intValueExact(),
									  id: row.spriden_id,
								username: username,
							   firstName: row.spriden_first_name,
								lastName: row.spriden_last_name,
							emailAddress: row.goremal_email_address]
			}

			sql.close()
			
			
		} catch (Exception e) {
			log.error("Error selecting user deteails.", e)
			sql?.close()
		}

		return person
	}
	
	/**
	 * @param username
	 * @return
	 */
	def getPersonForPIDM(int pidm) {
		def sql
		def person = [:]
		
		try {
			sql = new Sql(dataSource)
			def query = """\
				SELECT
				  spriden_pidm,
				  spriden_id,
				  spriden_first_name,
				  spriden_last_name,
				  goremal_email_address
				FROM
				  spriden
				JOIN goremal
				ON
				  goremal_pidm            = spriden_pidm
				AND goremal_status_ind    = 'A'
				AND goremal_preferred_ind = 'Y'
				WHERE
				  spriden_change_ind IS NULL
				  AND spriden_entity_ind  = 'P'
				  AND spriden_pidm          = :pidm """.stripIndent()

			def result = sql.eachRow(query, [pidm: pidm]) { row ->
				person = [pidm: ((BigDecimal) row.spriden_pidm).intValueExact(),
									  id: row.spriden_id,
							   firstName: row.spriden_first_name,
								lastName: row.spriden_last_name,
							emailAddress: row.goremal_email_address]
			}
			
			sql.close()
			
			
		} catch (Exception e) {
			log.error("Error selecting user deteails.", e)
			sql?.close()
		}

		return person
	}

	/**
	 * @param pidm
	 * @return
	 */
	def getEligibleSubjects(int pidm) {
		def sql
		def eligibleSubjects = []
		
		try {
			sql = new Sql(dataSource)
			
			def query = """\
							SELECT
			     ssbsect_subj_code || ssbsect_crse_numb || '_' || ssbsect_term_code || '_' || ssbsect_camp_code || '_' || ssbsect_sess_code AS subject_enrolment
			     ,ssbsect_crn as subject_crn
			     ,ssbsect_term_code as subject_session
			     ,ssbsect_subj_code || ssbsect_crse_numb as subject_code
			     ,ssbsect_camp_code as subject_campus
			     ,ssbsect_sess_code as subject_mode
			     ,CASE
			        WHEN swvtran_grde_code IN ('FL','PS','CR','DI','HD','FW','SY','US','AW','IP','NA','WD')
			          THEN 'N'
			        WHEN swvtran_grde_code IS NULL
			          THEN 'Y'
			        ELSE 'Y'
			      END AS eligible_subject
			     ,TO_CHAR(st.STVTERM_END_DATE, 'dd/mm/yyyy') as term_end_date
			     ,TO_CHAR(ssbsect_census_enrl_date, 'dd/mm/yyyy') as census_date
			     ,(select
			            CASE
			              WHEN count(*) > 0
			                THEN 'Y'
			              ELSE 'N'
			            END
			     from ssrmeet
			     where ssrmeet_crn = ssbsect_crn
			     and ssrmeet_term_code = ssbsect_term_code) as residential_school
			FROM STVTERM st,
			    (SELECT
			          *
			     FROM
			         sfrstcr e1
			        ,ssbsect o1
			     WHERE e1.sfrstcr_pidm    = :pidm
			     AND o1.ssbsect_crn       = e1.sfrstcr_crn
			     AND o1.ssbsect_term_code = e1.sfrstcr_term_code
			     AND o1.ssbsect_subj_code <> 'XLV'
			     AND o1.ssbsect_subj_code <> 'SSS'
			     AND e1.sfrstcr_rsts_code <> 'DD'
			    ) o1
			LEFT OUTER JOIN swvtran g1
			    ON  g1.swvtran_subj_code  = o1.ssbsect_subj_code
			    AND g1.swvtran_crse_numb  = o1.ssbsect_crse_numb
			    AND g1.swvtran_camp_code  = o1.ssbsect_camp_code
			    AND g1.swvtran_study_mode = o1.ssbsect_sess_code
			    AND g1.swvtran_term_code  = o1.ssbsect_term_code
			    AND g1.swvtran_pidm       = :pidm
			WHERE st.STVTERM_CODE         = o1.ssbsect_term_code
			ORDER BY ssbsect_term_code, ssbsect_subj_code, ssbsect_crse_numb, ssbsect_term_code, ssbsect_camp_code  """.stripIndent()
			
			sql.eachRow(query, [pidm: pidm]) { row ->
				eligibleSubjects.add([subjectEnrolment: row.subject_enrolment,
					crn: row.subject_crn,
					termCode: row.subject_session,
					subjectCode: row.subject_code,
					campus: row.subject_campus,
					mode: row.subject_mode,
					isEligible: row.eligible_subject, 
					termEndDate: row.term_end_date,
					census_date: row.census_date,
					residential_school: row.residential_school])
			}
			
			sql.close()
			
		} catch (Exception e) {
			sql?.close()
			log.error("Error selecting subjects", e)
		}
		
		return eligibleSubjects
	}
	
	/**
	 * Retrieves the details, including Subject Code, Mode, Campus and Name for a subject CRN and Term.
	 * 
	 * @param crn the selected CRN.
	 * @param termCode the selected Term
	 * 
	 * @return a Map containing the subject details.
	 */
	def getSubjectDetail(String crn, String termCode) {
		def sql
		def subjectDetail = [:]
		
		try {
			sql = new Sql(dataSource)
			
			def query = """\
				SELECT
				  ssbsect_subj_code
				  || ssbsect_crse_numb AS subject_code,
				  ssbsect_ptrm_code    AS subject_mode,
				  ssbsect_camp_code    AS campus_code,
				  ssbsect_crn          AS crn,
				  ssbsect_term_code    AS term_code,
				  scbcrse_title AS subject_name
				FROM
				  ssbsect
				JOIN scbcrse
				ON
				  scbcrse.scbcrse_subj_code   = ssbsect_subj_code
				AND scbcrse.scbcrse_crse_numb = scbcrse_crse_numb
				AND scbcrse.scbcrse_eff_term  =
				  (
				    SELECT
				      MAX(scbcrse_eff_term)
				    FROM
				      scbcrse maxterm
				    WHERE
				      maxterm.scbcrse_subj_code   = ssbsect_subj_code
				    AND maxterm.scbcrse_crse_numb = scbcrse_crse_numb
				    AND maxterm.scbcrse_eff_term <= :termCode
				  )
				WHERE
				  ssbsect_term_code = :termCode
				AND ssbsect_crn     = :crn """.stripIndent()
				
			def result = sql.firstRow(query, [crn: crn, termCode: termCode])
			if (result) {
				subjectDetail = [subjectCode: result.subject_code, 
					                  campus: result.campus_code, 
									    mode: result.subject_mode, 
										 crn: crn, 
									termCode: termCode, 
								 subjectName: result.subject_name]
			}
			sql.close()
						
		} catch (Exception e) {
			sql?.close()
			log.error("Unable to select subject", e)
		}
		
		return subjectDetail
	}
	
	/**
	 * @param campusCode
	 * @return
	 */
	def getCampusDetails(String campusCode) {
		def sql
		def campusDetails = [:]
		
		try {
			sql = new Sql(dataSource)
			
			def query = """\
				SELECT
				  stvcamp_code,
				  stvcamp_desc
				FROM
				  stvcamp
				WHERE
				  stvcamp_code = :campusCode """.stripIndent()
			
			def result = sql.firstRow(query, [campusCode: campusCode])
			campusDetails = [campusCode: result.stvcamp_code, campusName: result.stvcamp_desc]
			sql.close()
			
		} catch (Exception e) {
			sql?.close()
			log.error("Unable to select campus", e)
		}
		
		return campusDetails
	}

	/**
	 * @param pidm
	 * @return
	 */
	def getCourseDetails(int pidm, String termCode) {
		def sql
		def courseDetails = []
		int term = Integer.parseInt(termCode)

		try {
			sql = new Sql(dataSource)
			
			def query = """\
				SELECT s1.sgbstdn_program_1 as PROGRAM_CODE,
					   s1.sgbstdn_term_code_eff as TERM_CODE_EFFECTIVE,  
					   s2.SWRCRSN_FULL_NAME as PROGRAM_NAME 
				FROM sgbstdn s1, CSU.SWRCRSN s2
				WHERE s1.sgbstdn_pidm = :pidm
					AND s1.sgbstdn_term_code_eff =  (select max (s2.sgbstdn_term_code_eff)
				  FROM sgbstdn s2
				  WHERE s1.sgbstdn_pidm = s2.sgbstdn_pidm
				  AND s2.sgbstdn_term_code_eff <= :term)
				    AND (s1.sgbstdn_stst_code = 'AS')
				AND s2.SWRCRSN_PROGRAM = s1.SGBSTDN_PROGRAM_1
				AND s2.swrcrsn_term_eff_begin = (select max(s3.swrcrsn_term_eff_begin)
				        FROM swrcrsn s3
				        WHERE s3.swrcrsn_program = s2.swrcrsn_program 
				        AND s3.swrcrsn_term_eff_begin <= s1.SGBSTDN_TERM_CODE_EFF 
				        )""".stripIndent()
			
			sql.eachRow(query, [pidm: pidm, term: term]){ row ->
				courseDetails.add([programCode: row.PROGRAM_CODE, effectiveTermCode: row.TERM_CODE_EFFECTIVE, programName: row.PROGRAM_NAME])
				
			}
			
			sql.close()
			
		} catch (Exception e) {
			sql?.close()
			log.error("Unable to select Course details", e)
		}
		
		return courseDetails
	}

	/**
	 * @param 
	 * @return
	 */
	def getCurrentTerms() {
		def sql
		def currentTerms = [:]

		try {
			sql = new Sql(dataSource)
			
			def query = """\
				select
					ct1.STVTERM_CODE as TERM_CODE,
					ct1.STVTERM_START_DATE as TERM_START_DATE,
					ct1.STVTERM_END_DATE as TERM_END_DATE
				FROM stvterm ct1
				WHERE substr(ct1.STVTERM_CODE,5,2) in ('15', '30', '45', '60', '75', '90')
					AND ct1.STVTERM_START_DATE <= sysdate
					AND ct1.STVTERM_END_DATE >= sysdate
					ORDER by ct1.STVTERM_CODE desc""".stripIndent()
			
			def result = sql.firstRow(query)
			if (result) {
				currentTerms = [termCode: result.TERM_CODE, termStartDate: result.TERM_START_DATE, termEndDate: result.TERM_END_DATE]
			}
			
			
			sql.close()
			
		} catch (Exception e) {
			sql?.close()
			log.error("Unable to select current term details", e)
		}
		
		return currentTerms
	}
	
}
