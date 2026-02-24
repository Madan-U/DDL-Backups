-- Object: PROCEDURE dbo.rpt_fotodaysbill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 4/30/01 5:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotodaysbill    Script Date: 12/27/00 8:59:11 PM ******/
/* Report : Fo billreport
   File : tbillreport.asp
 displays the bqty, sqty of a client on the given date
*/
CREATE PROCEDURE rpt_fotodaysbill
@code varchar(10),
@sdate varchar(12)
AS
select distinct a.party_code, t.inst_type, t.symbol,convert(varchar,t.expirydate,106) as expirydate,
convert(varchar,a.billdate,106) as billdate,a.amount,a.bill_no,
bqty = isnull((select sum(tradeqty) from fosettlement s where s.party_code = a.party_code and
        convert(varchar,s.sauda_date,103) = convert(varchar,a.billdate,103) and sell_buy = 1 ),0),
sqty = isnull((select sum(tradeqty) from fosettlement s where s.party_code = a.party_code and
        convert(varchar,s.sauda_date,103) = convert(varchar,a.billdate,103) and sell_buy = 2 ),0)
from foaccbill a, fosettlement t
where a.party_code = @code and 
a.party_code = t.party_code and
convert(varchar,billdate,103) =convert(varchar,sauda_date,103) and
convert(varchar,billdate,103) = @sdate

GO
