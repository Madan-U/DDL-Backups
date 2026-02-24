-- Object: PROCEDURE dbo.rpt_fomthcal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 5/5/2001 1:24:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 4/30/01 5:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomthcal    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : netposition.asp
Tables Used  : foclosing
Function     : Returns month of a particular expirydate
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomthcal
@mth varchar(5)
AS
select distinct convert(varchar,expirydate,106) 
from foclosing 
where left(right(convert(varchar,expirydate,106),8),3) = @mth

GO
