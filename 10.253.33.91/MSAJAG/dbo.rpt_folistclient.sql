-- Object: PROCEDURE dbo.rpt_folistclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_folistclient    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : Billmain
Tables Used  : fosettlement
Function     : Returns all the partycodes
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_folistclient
AS
select distinct "<option value="+rtrim(party_code)+">"+rtrim(party_code)+"</option>" 
from fosettlement

GO
