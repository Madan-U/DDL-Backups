-- Object: PROCEDURE dbo.rpt_albmlscripmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmlscripmargin    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmlscripmargin    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmlscripmargin    Script Date: 20-Mar-01 11:38:53 PM ******/





/****** Object:  Stored Procedure dbo.rpt_albmlscripmargin    Script Date: 12/27/00 8:59:08 PM ******/
/****** Object:  Stored Procedure dbo.rpt_albmlscripmargin    Script Date: 1/12/01 9:25:00 PM ******/
/* report : bill report
    file : albmwbill.asp 
*/
/* displays margin for a scrip for a settlement for l type*/
CREATE PROCEDURE rpt_albmlscripmargin
@settno varchar(7),
@scripcd varchar(12)
AS
select addmargin from margin2 where sett_no=@settno and sett_type='L' and scrip_cd=@scripcd

GO
