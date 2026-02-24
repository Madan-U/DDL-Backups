-- Object: PROCEDURE dbo.rpt_fomembermargin1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 5/5/2001 1:24:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 4/30/01 5:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomembermargin1    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fomembermargin1
@sdate varchar(12)
/*,
@inst varchar(12),
@symbol varchar(10),
@expdate varchar(12)*/
AS
select party_code, spreadqty, nonspreadqty, ex_spreadmargin, ex_nonspreadmargin, 
inst_type, symbol, convert(varchar,expirydate,106) as expirydate, cl_rate
from fomargin
where left(convert(varchar,MARGIN_DATE,109),11) = @sdate
order by expirydate
/*
select party_code, spreadqty, nonspreadqty, ex_spreadmargin, ex_nonspreadmargin, 
inst_type, symbol, convert(varchar,expirydate,106) as expirydate, cl_rate
from fomargin
where convert(varchar,MARGIN_DATE,106) = @sdate
and inst_type = @inst
and symbol = @symbol
and convert(varchar,expiryDATE,106) = @expdate
order by expirydate
*/

GO
