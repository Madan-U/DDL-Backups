-- Object: PROCEDURE dbo.rpt_contrtraderwisec
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrtraderwisec    Script Date: 04/21/2001 6:05:21 PM ******/

create procedure rpt_contrtraderwisec 
@branchcd varchar(3)
as
select qty = sum(t4.tradeqty),amount = sum(t4.tradeqty *t4.marketrate ),t4.sell_buy ,br.short_name
from trade4432 t4,branches br ,client1 c1 ,client2 c2
where c1.cl_code =c2.cl_code and c1.trader = br.short_name
and t4.party_code =c2.party_code and br.branch_cd = @branchcd
group by br.short_name ,t4.sell_buy 
order by br.short_name ,t4.sell_buy

GO
