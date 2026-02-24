-- Object: PROCEDURE dbo.rpt_albmwscripmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmwscripmargin    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwscripmargin    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwscripmargin    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmwscripmargin    Script Date: 12/27/00 8:59:08 PM ******/
/* report : bill report
    file : albmwbill.asp 
*/
/* displays margin for a scrip for a settlement */
CREATE PROCEDURE rpt_albmwscripmargin
@settno varchar(7),
@scripcd varchar(12)
AS
select addmargin from margin2 where sett_no=@settno and sett_type='p' and scrip_cd=@scripcd

GO
