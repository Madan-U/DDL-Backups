-- Object: PROCEDURE dbo.rpt_congexsbcltts
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexsbcltts    Script Date: 04/21/2001 6:05:19 PM ******/

/*written by neelambari on 4 april 2001*/
/*this query gives us the list of clients and all details of   trading of each client from
  trade and settlement for selected subbroker
*/
CREATE procedure  rpt_congexsbcltts
@settno varchar(7),
@settype varchar(3),
@subbroker varchar(10)
as
	select c2.party_code , c1.short_name ,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy ,src='all'
	from trade t4,client1 c1,client2 c2 ,subbrokers sb
	where c2.party_code = t4.party_code 
	and c1.cl_code    = c2.cl_code 
	and sb.sub_broker = c1.sub_broker
	and c1.sub_broker = @subbroker
	group by    c2.party_code ,t4.sell_buy ,c1.short_name
	Union all 
	select  c2.party_code ,c1.short_name , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy , src ='all'
	from settlement t4,client1 c1,client2 c2  ,subbrokers sb
	where c2.party_code = t4.party_code 
	and c1.cl_code    = c2.cl_code 
	and t4.sett_no    = @settno
	and t4.sett_type  = @settype
	and sb.sub_broker = c1.sub_broker
	and c1.sub_broker = @subbroker
	group by    c2.party_code ,t4.sell_buy ,c1.short_name
	union all
	select  c2.party_code ,c1.short_name , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy,src='albm' 
	from settlement t4,client1 c1,client2 c2  ,subbrokers sb
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and t4.sett_no = @settno
	and t4.sett_type ='l'
	and sb.sub_broker = c1.sub_broker
	and c1.sub_broker = @subbroker
	 and
	 t4.party_code not in( select distinct party_code from settlement  where sett_no=@settno and sett_type=@settype)
	group by    c2.party_code ,t4.sell_buy ,c1.short_name
	order by  c2.party_code ,t4.sell_buy ,c1.short_name

GO
