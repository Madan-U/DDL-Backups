-- Object: PROCEDURE dbo.rpt_congexbrwiset4ts
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexbrwiset4ts    Script Date: 04/21/2001 6:05:19 PM ******/

/*written by neelambari on 31 mar 2001*/
/*this query gives us the branch name and all details of   trading of each branch from
  trade4432 and settlement
*/
create procedure   rpt_congexbrwiset4ts
@settno varchar(7),
@settype varchar(3)
as
	select br.branch_cd ,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade4432 t4,client1 c1,client2 c2 ,branches br
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and br.short_name=c1.trader
	group by  br.branch_cd ,t4.sell_buy 
	Union all 
	select br.branch_cd ,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from settlement t4,client1 c1,client2 c2 ,branches br
	where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and br.short_name=c1.trader
	and t4.sett_no = @settno
	and t4.sett_type =@settype
	group by  br.branch_cd ,t4.sell_buy 
	order by  br.branch_cd ,t4.sell_buy

GO
