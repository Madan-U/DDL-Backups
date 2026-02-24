-- Object: PROCEDURE dbo.rpt_contrcltoftrdc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrcltoftrdc    Script Date: 04/21/2001 6:05:20 PM ******/

create procedure  rpt_contrcltoftrdc
@trader varchar(20)
as
select qty =sum(t4.tradeqty),t4.sell_buy,amount=sum(t4.tradeqty * t4.marketrate) ,c1.short_name ,c2.party_code
from trade4432 t4  ,client1 c1 ,client2 c2 
where c1.cl_code =c2.cl_code 
and t4.party_code =c2.party_code 
and c1.trader = @trader
group by c2.party_code , c1.short_name ,t4.sell_buy 
order by c2.party_code , c1.short_name ,t4.sell_buy

GO
