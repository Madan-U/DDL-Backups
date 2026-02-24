-- Object: PROCEDURE dbo.rpt_fospreaddetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 4/30/01 5:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fospreaddetails    Script Date: 12/27/00 8:59:11 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : spreaddetail.asp
Tables Used  : margin, fonsespmargin, client3
Function     : Returns spreadqty, spreadmth, pmarginrate for a particular contract descriptor
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fospreaddetails
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12),
@code varchar(10)
AS
select distinct spreadqty,spreadmth, f.spreadmargin, pmarginrate
from fomargin m, fonsespmargin f, client3 c3
where m.inst_type = @inst
and m.symbol = @symbol
and convert(varchar,expirydate,106) = @expdate
and m.party_code = c3.party_code
and c3.party_code = @code
group by spreadqty,spreadmth, f.spreadmargin, pmarginrate,cl_rate

GO
