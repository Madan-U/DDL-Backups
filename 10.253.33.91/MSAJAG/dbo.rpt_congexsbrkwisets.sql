-- Object: PROCEDURE dbo.rpt_congexsbrkwisets
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexsbrkwisets    Script Date: 04/21/2001 6:05:19 PM ******/

/*written by neelambari on 31 mar 2001*/
/*this query gives us the subbrokers  name and all details of
  trading of each subbroker from trade and settlement
*/
CREATE procedure rpt_congexsbrkwisets
@settno varchar(7),
@settype varchar(3)
as
	select c1.sub_broker  ,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade t4,client1 c1,client2 c2 ,subbrokers sb
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and c1.sub_broker = sb.sub_broker
	group by c1.sub_broker ,t4.sell_buy 
	Union all 
	select c1.sub_broker  ,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from settlement t4,client1 c1,client2 c2 ,subbrokers sb
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and c1.sub_broker = sb.sub_broker
	and t4.sett_no = @settno
	and t4.sett_type =@settype
	group by  c1.sub_broker  ,t4.sell_buy 
	order by  c1.sub_broker  ,t4.sell_buy

GO
