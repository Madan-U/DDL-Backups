-- Object: PROCEDURE dbo.rpt_fomaxexpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 5/5/2001 1:24:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 4/30/01 5:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomaxexpdate    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : spreaddetail
Tables Used  : foclosing
Function     : Returns expirydate
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomaxexpdate
@inst varchar(6),
@symbol varchar(12)
AS
select convert(varchar,max(expirydate),106) 
from foclosing where inst_type = @inst
and symbol = @symbol

GO
