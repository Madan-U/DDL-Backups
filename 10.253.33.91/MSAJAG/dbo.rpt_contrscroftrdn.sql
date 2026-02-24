-- Object: PROCEDURE dbo.rpt_contrscroftrdn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrscroftrdn    Script Date: 04/21/2001 6:05:21 PM ******/

/*
this gives us the list of scrips of selected trader
whose trades are not confirmed and trade details
*/
create procedure rpt_contrscroftrdn
@trader varchar(20)
as
select qty =sum(o.qty-o.tradeqty),o.sell_buy ,
o.scrip_cd
from orders o ,client1 c1 ,client2 c2 
where c1.cl_code =c2.cl_code 
and o.party_code =c2.party_code 
and c1.trader = @trader
group by  o.scrip_cd ,o.sell_buy 
order by o.scrip_cd,o.sell_buy

GO
