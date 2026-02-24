-- Object: PROCEDURE dbo.rpt_bankname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bankname    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_bankname    Script Date: 01/04/1980 5:06:26 AM ******/




/****** Object:  Stored Procedure dbo.rpt_bankname    Script Date: 2/17/01 5:19:39 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bankname    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankname    Script Date: 20-Mar-01 11:38:54 PM ******/

/*
Modified by neelambari on 1 mar 2001
added account.dbo before table acmast
*/

/* report: cheques
   file: cheques.asp
*/
/* shows list of all available bank accounts */

CREATE PROCEDURE rpt_bankname
AS
select acname,cltcode from account.dbo.acmast where accat='2'

GO
