-- Object: PROCEDURE dbo.rpt_albmnfixmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmnfixmargin    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmnfixmargin    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmnfixmargin    Script Date: 20-Mar-01 11:38:53 PM ******/





/****** Object:  Stored Procedure dbo.rpt_albmnfixmargin    Script Date: 12/27/00 8:59:08 PM ******/
/****** Object:  Stored Procedure dbo.rpt_albmnfixmargin    Script Date: 1/12/01 9:25:01 PM ******/
/* billreport
   file: albmwbill.asp
   finds fixmargin for a settlement number and type
*/
CREATE PROCEDURE rpt_albmnfixmargin
@settno varchar(7)
AS
select fixmargin from margin1 where sett_no=@settno and sett_type='L'

GO
