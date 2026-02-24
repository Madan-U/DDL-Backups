-- Object: PROCEDURE dbo.rpt_fomarginmtom
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomarginmtom    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : margin.asp
Tables Used  : fotrade
Function     : Returns netvalue of a particular contract descriptor
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomarginmtom
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12),
@code varchar(10)
AS
select sum(tradeqty * price) 
from fotrade
where inst_type = @inst 
and symbol = @symbol
and convert(varchar,expirydate,106) = @expdate
and party_code = @code

GO
