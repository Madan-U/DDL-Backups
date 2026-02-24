-- Object: PROCEDURE dbo.rpt_settno1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settno1    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settno1    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settno1    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settno1    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settno1    Script Date: 12/27/00 8:58:58 PM ******/

/* report : position report 
   file : positionmain.asp
   report : bills report
   file : billmain.asp 
 */
/* report : netposition (nse) report 
   file : netnsemain.asp */
/* displays settlement numbers from settlement */
CREATE PROCEDURE rpt_settno1

/*@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)*/

AS

select distinct sett_no  
from settlement
union
select distinct sett_no  
from history
order by sett_no desc

GO
