-- Object: PROCEDURE dbo.rpt_congexalbmwprev
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbmwprev    Script Date: 04/21/2001 6:05:19 PM ******/

/*find albm trades for w type  for perv sett no*/
create proc rpt_congexalbmwprev
@branch varchar(3),
@settno varchar(10)
as
select qty=sum(s.tradeqty),
Amount=sum(s.tradeqty*s.rate),s.sell_buy 
from albmgrossexp s,client1 c1,client2 c2 ,branches br
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code 
and sett_no=@settno and br.branch_cd = @branch
and br.short_name = c1.trader
group by s.sell_buy 
order by  s.sell_buy

GO
