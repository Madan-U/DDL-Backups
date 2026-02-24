-- Object: PROCEDURE dbo.rpt_contrscrofsbrkc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrscrofsbrkc    Script Date: 04/21/2001 6:05:20 PM ******/

/*
this query gives us list of scrips for selected subbroker which are confirmed 
*/
create procedure rpt_contrscrofsbrkc
@subbroker varchar(13)
as
select qty =sum(t4.tradeqty),t4.sell_buy 
,amount = sum(t4.tradeqty * t4.marketrate) ,t4.scrip_cd
from trade4432 t4  ,client1 c1 ,client2 c2 
where c1.cl_code =c2.cl_code 
and t4.party_code =c2.party_code 
and c1.sub_broker = @subbroker
group by  t4.scrip_cd ,t4.sell_buy 
order by  t4.scrip_cd,t4.sell_buy

GO
