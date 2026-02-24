-- Object: PROCEDURE dbo.rpt_fotradercode
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 4/30/01 5:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotradercode    Script Date: 12/27/00 8:59:11 PM ******/
/*
Used In      : NSE FO
Report Name  : tradewisebill Report
File Name    : clientlist.asp
Tables Used  : client1, client2, foaccbill
Function     : Returns partycode, shortname, amount under particular trader 
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fotradercode
@trader varchar(15),
@code varchar(10),
@fdate varchar(12),
@tdate varchar(12)
AS
select distinct c2.party_code,c1.short_name ,f.amount, convert(varchar,f.billdate,106) as billdate,
f.sell_buy, billdate as bill
from client1 c1, client2 c2, foaccbill f
where c1.trader = @trader
and c2.party_code = @code
and billdate between @fdate and @tdate + ' 23:59'
and c1.cl_code = c2.cl_code
and f.party_code = c2.party_code
order by bill

GO
