-- Object: PROCEDURE dbo.rpt_fospmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 4/30/01 5:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fospmargin    Script Date: 12/27/00 8:59:11 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : spreaddetail.asp
Tables Used  : margin
Function     : Returns the spreadmargin, nonspread margin of a particular code
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fospmargin
@code varchar(10),
@sdate varchar(12)
AS
select inst_type, symbol, convert(varchar,expirydate,106) as expirydate,
spreadmargin,nonspreadmargin , convert(varchar,margin_date,106) as sdate
from fomargin 
where party_code = @code
and convert(varchar,margin_date,106) =@sdate

GO
