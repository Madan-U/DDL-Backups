-- Object: PROCEDURE dbo.rpt_fomembermargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 5/5/2001 1:24:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 4/30/01 5:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomembermargin    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fomembermargin
@inst varchar(12),
@symbol varchar(21),
@expdate varchar(12),
@sdate varchar(12)
AS
select party_code, convert(varchar,margin_date,106) as margin_date, 
convert(varchar,expirydate,106) as expirydate, inst_type, symbol, spreadqty, 
nonspreadqty, spreadmargin, nonspreadmargin,spreadmth,cl_rate,ex_spreadmargin,ex_nonspreadmargin
from fomargin
where inst_type = @inst
and symbol = @symbol
and convert(varchar,expirydate,106) = @expdate
and convert(varchar,margin_date,106) = @sdate

GO
