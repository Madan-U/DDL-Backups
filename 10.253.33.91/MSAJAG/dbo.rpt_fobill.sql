-- Object: PROCEDURE dbo.rpt_fobill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 5/7/2001 9:02:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 5/5/2001 2:43:35 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 5/5/2001 1:24:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 4/30/01 5:50:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 10/26/00 6:04:40 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fobill    Script Date: 12/27/00 8:59:09 PM ******/
/*Modified by Amolika on 13th April'2001 : Added like for partycode and matched code from foaccbill & 
  fosettlement*/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : billreport.asp
Tables Used  : foaccbill
Function     : Returns sell_buy, amount, billdate 
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fobill
@fcode varchar(10),
@tcode varchar(10),
@fdate varchar(12),
@tdate varchar(12)
AS

select distinct convert(varchar,billdate,106) as billdate, a.amount , a.sell_buy, billdate as bill,
a.party_code,a.bill_no
from foaccbill a, fosettlement s
where billdate between @fdate and @tdate + ' 23:59' 
and a.party_code >= @fcode and a.party_code <= @tcode
and a.party_code = s.party_code
order by a.party_code, bill,bill_no




/*
select distinct convert(varchar,billdate,106) as billdate, a.amount , a.sell_buy, billdate as bill,
a.party_code,a.bill_no
from foaccbill a, fosettlement s
where billdate between @fdate and @tdate + ' 23:59' 
and a.party_code like ltrim(@code)+'%'
and a.party_code = s.party_code
order by a.party_code, bill,bill_no

select distinct convert(varchar,billdate,106) as billdate, amount , sell_buy, billdate as bill, party_code
from foaccbill 
where billdate between @fdate and @tdate + ' 23:59' 
and party_code like ltrim(@code)+'%'
order by party_code, bill
*/

GO
