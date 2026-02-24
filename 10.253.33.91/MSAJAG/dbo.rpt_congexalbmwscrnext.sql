-- Object: PROCEDURE dbo.rpt_congexalbmwscrnext
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbmwscrnext    Script Date: 04/21/2001 6:05:19 PM ******/

/*this queery gives us the albm trades for next settno for particular scrip */

create procedure rpt_congexalbmwscrnext
@nextsettno varchar(10),
@scripcd varchar(10)
as
select s.sell_buy, s.tradeqty, s.marketrate , a.rate
from settlement s, client2 c2, client1 c1, albmrate a ,branches br
where s.scrip_cd = @scripcd
and c2.party_code=s.party_code 
and c1.trader = br.short_name
and c1.cl_code=c2.cl_code  
and s.sett_no = @nextsettno
and s.sett_type ='p'
and a.sett_no=s.sett_no
and a.sett_type=s.sett_type
and a.scrip_cd=s.scrip_cd
and a.series=s.series
order by s.sell_buy

GO
