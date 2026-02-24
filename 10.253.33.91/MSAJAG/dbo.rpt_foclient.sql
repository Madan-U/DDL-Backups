-- Object: PROCEDURE dbo.rpt_foclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 4/30/01 5:50:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclient    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Tradewise Bill Report
File Name    : clientlist.asp
Tables Used  : client1, client2, foaccbill
Function     : Returns partycode, shortname & amount of a particular trader
Written By   : Amolika Patil 
Modified by amolika on 12th feb : selected sell_buy, billdate from foaccbil
*/
CREATE PROCEDURE rpt_foclient
@trader varchar(15),
@fdate varchar(12),
@tdate varchar(12)
AS
select distinct c2.party_code,c1.short_name ,f.amount, f.sell_buy, billdate
from client1 c1, client2 c2, foaccbill f
where c1.trader = @trader
and c1.cl_code = c2.cl_code
and f.party_code = c2.party_code
and billdate between @fdate and @tdate + ' 23:59'
order by c2.party_code, billdate

GO
