-- Object: PROCEDURE dbo.rpt_contrscrofsbrkn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrscrofsbrkn    Script Date: 04/21/2001 6:05:21 PM ******/

/*
this query gives us list of scrips for selected
 subbroker which are not confirmed 
*/
create procedure rpt_contrscrofsbrkn
@subbroker varchar(13)
as
select qty =sum(o.qty-o.tradeqty),o.sell_buy ,o.scrip_cd
from orders o  ,client1 c1 ,client2 c2 
where c1.cl_code =c2.cl_code 
and o.party_code =c2.party_code 
and c1.sub_broker = @subbroker
group by  o.scrip_cd ,o.sell_buy 
order by  o.scrip_cd,o.sell_buy

GO
