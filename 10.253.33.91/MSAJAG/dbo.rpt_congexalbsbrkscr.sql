-- Object: PROCEDURE dbo.rpt_congexalbsbrkscr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbsbrkscr    Script Date: 04/21/2001 6:05:19 PM ******/

/*
Writte nby neelambari on 5 april 2001
this query gives us albm transactions for a partiular subbrokers  particular scrip
*/
create procedure rpt_congexalbsbrkscr
@settno varchar(10),
@subbroker varchar (20),
@scrip varchar(15)
as
select   s.scrip_cd,s.series,qty=sum(s.tradeqty),s.sell_buy 
from settlement s,client1 c1,client2 c2 , subbrokers sb
where
c2.party_code  = s.party_code 
and c1.cl_code = c2.cl_code 
and sett_no    = @settno
and sett_type  ='l' 
and c1.sub_broker= sb.sub_broker
and c1.sub_broker = @subbroker
and s.scrip_cd = @scrip
group by c1.sub_broker , s.scrip_cd , s.series , s.sell_buy 
order by c1.sub_broker ,  s.scrip_cd , s.series , s.sell_buy

GO
