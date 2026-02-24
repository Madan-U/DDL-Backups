-- Object: PROCEDURE dbo.rpt_onlyalbmtransactions
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_onlyalbmtransactions    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_onlyalbmtransactions    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_onlyalbmtransactions    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_onlyalbmtransactions    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_onlyalbmtransactions    Script Date: 12/27/00 8:58:57 PM ******/

/* report : misnews
   file : topclient_scripsett.asp
*/
/* shows albm transactions for a particular settlement */
CREATE PROCEDURE rpt_onlyalbmtransactions
@settno varchar(7),
@partycode varchar(10)
AS
select s.series,s.scrip_cd,s.sell_buy,qty=sum(s.tradeqty), c1.cl_code,c1.short_name ,
rate=isnull((select distinct rate from albmrate a where a.sett_no=s.sett_no and a.sett_type=s.sett_type and a.scrip_cd=s.scrip_cd),0)
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.party_code=@partycode
and s.sett_type='l' 
and s.sett_no=@settno
group by c1.cl_code,c1.short_name,s.sett_no,s.sett_type,s.series,s.scrip_Cd,s.sell_buy
order by c1.short_name,c1.cl_code,s.scrip_Cd,s.sell_buy

GO
