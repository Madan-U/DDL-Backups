-- Object: PROCEDURE dbo.rpt_congexalbmtrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbmtrd    Script Date: 04/21/2001 6:05:19 PM ******/

/*this procedure gives us albm trades for particular trader os particular branch*/
create procedure rpt_congexalbmtrd
@settno varchar(7),
@branch varchar(3),
@trader varchar(20)
as
select c1.trader, s.scrip_cd,s.series,qty=sum(s.tradeqty),s.sell_buy 
from settlement s,client1 c1,client2 c2 , BRANCHES BR
where
c2.party_code  = s.party_code 
and c1.cl_code = c2.cl_code 
and sett_no    = @settno
and sett_type  ='l' 
and br.short_name = c1.trader
and br.branch_cd = @branch
and c1.trader = @trader
group by c1.trader , s.scrip_cd , s.series , s.sell_buy 
order by c1.trader ,  s.scrip_cd , s.series , s.sell_buy

GO
