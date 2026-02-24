-- Object: PROCEDURE dbo.rpt_settdisp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settdisp    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settdisp    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settdisp    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settdisp    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settdisp    Script Date: 12/27/00 8:58:58 PM ******/

/* Report : settlement calender
   File : displaysett.asp
to display the settlement types
*/
CREATE PROCEDURE rpt_settdisp
AS
select distinct sett_type 
from sett_mst

GO
