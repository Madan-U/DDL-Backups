-- Object: PROCEDURE dbo.rpt_bankid
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bankid    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid    Script Date: 20-Mar-01 11:38:54 PM ******/





/****** Object:  Stored Procedure dbo.rpt_bankid    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bankid    Script Date: 12/27/00 8:58:53 PM ******/

/* report  : confirmation report 
   file : cl.asp
   selects bankid from bank
*/
CREATE PROCEDURE rpt_bankid AS
select distinct bankid from bank
 order by bankid

GO
