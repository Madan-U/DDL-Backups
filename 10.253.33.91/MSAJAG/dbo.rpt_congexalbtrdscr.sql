-- Object: PROCEDURE dbo.rpt_congexalbtrdscr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbtrdscr    Script Date: 04/21/2001 6:05:19 PM ******/

/*
Writte nby neelambari on 5 april 2001
this query gives us albm transactions for a partiular trader's particular scrip
*/
create procedure  rpt_congexalbtrdscr
@settno varchar(10),
@trader varchar (20),
@scrip varchar(15),
@series varchar(3)
as
select qty=sum(s.tradeqty),s.sell_buy 
from settlement s,client1 c1,client2 c2 , branches br
where
c2.party_code  = s.party_code 
and c1.cl_code = c2.cl_code 
and sett_no    = @settno
and sett_type  ='l' 
and c1.trader= br.short_name
and c1.trader = @trader
and s.scrip_cd = @scrip
and s.series = @series
group by  s.sell_buy 
order by  s.sell_buy

GO
