-- Object: PROCEDURE dbo.rpt_currentyr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE rpt_currentyr
as

/* finds current financial yr */

select convert(varchar,sdtcur,101) from account.dbo.parameter
where curyear=1

GO
