-- Object: PROCEDURE dbo.rpt_albmrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmrate    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmrate    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmrate    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmrate    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmrate    Script Date: 12/27/00 8:58:53 PM ******/



/* report :partywise turnover
   file:partywiseturn.asp
   displays albm rate for a scrip 
*/

	
CREATE PROCEDURE rpt_albmrate

@scripcd varchar(12),
@settno varchar(12)

AS

select rate from albmrate where scrip_cd=@scripcd  and sett_no=@settno

GO
