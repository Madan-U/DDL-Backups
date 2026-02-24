-- Object: PROCEDURE dbo.rpt_fononspreaddetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fononspreaddetail    Script Date: 12/27/00 8:59:11 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : nonspreaddetail.asp
Tables Used  : margin, fonsenspmargin, client3
Function     : Returns nonspread details for a particular contract descriptor
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fononspreaddetail
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12),
@code varchar(10)
AS
select distinct nonspreadqty,spreadmth, pmarginrate,cl_rate
from fomargin m, fonsenspmargin f, client3 c3
where f.inst_type = @inst
and f.symbol = @symbol
and convert(varchar,f.expirydate,106) = @expdate
and m.inst_type = f.inst_type
and m.symbol = f.symbol
and m.expirydate = f.expirydate
and m.party_code = c3.party_code
and c3.party_code = @code
group by nonspreadqty,spreadmth,  pmarginrate,cl_rate

GO
