-- Object: PROCEDURE dbo.rpt_congexalbmsbortrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexalbmsbortrd    Script Date: 04/21/2001 6:05:19 PM ******/

/*WRITTEN BY NEELAMBARI ON 4 APRIL 2001
 displays details of trades of a particular previous albm settlement 
*/
create procedure  rpt_congexalbmsbortrd 
@settno varchar(7),
@branch varchar(3)
as
select br.branch_cd , s.scrip_cd,s.series,qty=sum(s.tradeqty),s.sell_buy 
from settlement s,client1 c1,client2 c2 , BRANCHES BR
where
c2.party_code  = s.party_code 
and c1.cl_code = c2.cl_code 
and sett_no    = @settno
and sett_type  ='l' 
and br.short_name = c1.trader
and br.branch_cd = @branch
group by br.branch_cd , s.scrip_cd , s.series , s.sell_buy 
order by br.branch_cd , s.scrip_cd , s.series , s.sell_buy

GO
