-- Object: PROCEDURE dbo.rpt_congexscrpts
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexscrpts    Script Date: 04/21/2001 6:05:20 PM ******/

/*written by neelambari on 4 april 2001*/
/*this query gives us the list of scrips and all details of   trading of each scrip from
  trade and settlement
*/
create procedure rpt_congexscrpts
@settno varchar(7),
@settype varchar(3),
@trader varchar(15)
as
	select t4.scrip_cd , t4.series ,  qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade t4,client1 c1,client2 c2 
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and c1.trader = @trader
	group by    t4.scrip_cd ,t4.series ,t4.sell_buy 
	Union all 
	select    t4.scrip_cd ,t4.series , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from settlement t4,client1 c1,client2 c2  
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and t4.sett_no = @settno
	and t4.sett_type =@settype
	and c1.trader = @trader
	group by      t4.scrip_cd ,t4.series ,t4.sell_buy  
	order by   t4.scrip_cd ,t4.series ,t4.sell_buy

GO
