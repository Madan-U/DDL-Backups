-- Object: PROCEDURE dbo.rpt_fincheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : allpartyledger
    finds start and end date of current financial year
*/

CREATE PROCEDURE  rpt_fincheck

AS

select convert(varchar,sdtcur,101),convert(varchar,ldtcur,101) from account.dbo.parameter where curyear=1

GO
