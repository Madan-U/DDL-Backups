-- Object: PROCEDURE dbo.rpt_fononspmargindetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fononspmargindetail    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : nonspmargindetail.asp
Tables Used  : fonsenspmargin, client3
Function     : Returns nonspread details for a particular contract descriptor
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fononspmargindetail
@code varchar(10),
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12),
@sdate varchar(12)
AS
select nonspreadmargin, pmarginrate
from fonsenspmargin f,  client3
where party_code = @code
and f.inst_type = @inst
and f.symbol = @symbol
and markettype like 'Future%'
and convert(varchar,expirydate,106) = @expdate
and convert(varchar,date,106) = @sdate

GO
