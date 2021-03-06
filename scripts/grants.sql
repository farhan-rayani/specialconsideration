create public synonym STVSCST         for CSU.STVSCST;
create public synonym SWRSPEC         for CSU.SWRSPEC;
grant select on CSU.STVSCST to spcon_dml_role;
grant select,insert,update on CSU.SWRSPEC to spcon_dml_role;
grant select on WWW_ACCESS_NOPASS to spcon_dml_role;
grant select on SATURN.SPRIDEN to spcon_dml_role;
grant select on SATURN.SSBSECT to spcon_dml_role;
grant select on SATURN.SFRSTCR to spcon_dml_role;
grant select on CSU.SWVTRAN to spcon_dml_role;
grant select on SATURN.SCBCRSE to spcon_dml_role;
grant select on SATURN.STVCAMP to spcon_dml_role;
grant select on GOREMAL to spcon_dml_role;