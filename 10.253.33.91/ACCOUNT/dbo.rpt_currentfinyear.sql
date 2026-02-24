-- Object: PROCEDURE dbo.rpt_currentfinyear
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_currentfinyear    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_currentfinyear    Script Date: 11/28/2001 12:23:49 PM ******/



/* report : allpartyledger
     displays startdate of current financial year
*/

/* changed by mousami on 01/03/2001
 changed store procedure rpt_cltcodelist (removed hardcoding 
 for sharedatabase and added hardcoding for newaccount databse) */

CREATE PROCEDURE rpt_currentfinyear 

AS

select convert(varchar,sdtcur,103) from account.dbo.parameter where
curyear=1

GO
