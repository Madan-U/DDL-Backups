-- Object: PROCEDURE dbo.rpt_congexalbcltlstsb
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbcltlstsb    Script Date: 04/21/2001 6:05:18 PM ******/

/*
written by neelambari on 5 april 2001
This query gives us the albm trades  for selected subbroker for one partycode 
*/
create procedure rpt_congexalbcltlstsb
@settno varchar(7),
@subbroker varchar(10),
@partycode varchar(10)
as
select  c2.party_code ,c1.short_name , s.scrip_cd , s.series,qty=sum(s.tradeqty),s.sell_buy 
from settlement s,client1 c1,client2 c2 ,subbrokers sb
where
c2.party_code  = s.party_code 
and s.party_code = @partycode
and c1.cl_code = c2.cl_code 
and sett_no    = @settno
and sett_type  ='l' 
and sb.sub_broker = @subbroker
and c1.sub_broker = sb.sub_broker 
group by c2.party_code , s.scrip_cd , s.series , s.sell_buy ,c1.short_name
order by c2.party_code , s.scrip_cd , s.series , s.sell_buy ,c1.short_name

GO
