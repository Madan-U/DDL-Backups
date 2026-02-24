-- Object: PROCEDURE dbo.rpt_currentfinyear1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_currentfinyear1    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_currentfinyear1    Script Date: 01/04/1980 5:06:26 AM ******/






/****** Object:  Stored Procedure dbo.rpt_currentfinyear1    Script Date: 09/07/2001 11:09:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_currentfinyear1    Script Date: 3/23/01 7:59:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_currentfinyear1    Script Date: 08/18/2001 8:24:11 PM ******/


/****** Object:  Stored Procedure dbo.rpt_currentfinyear    Script Date: 04/27/2001 4:32:38 PM ******/
/* report : allpartyledger
     displays startdate of current financial year
*/

/* changed by mousami on 01/03/2001
 changed store procedure rpt_cltcodelist (removed hardcoding 
 for sharedatabase and added hardcoding for account databse) */
 
CREATE PROCEDURE rpt_currentfinyear1 

AS

select convert(varchar,sdtcur,101) from account.dbo.parameter where
curyear=1

GO
