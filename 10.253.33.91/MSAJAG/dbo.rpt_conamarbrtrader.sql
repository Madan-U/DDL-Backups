-- Object: PROCEDURE dbo.rpt_conamarbrtrader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamarbrtrader    Script Date: 04/21/2001 6:05:18 PM ******/

/* report :albmmargin
     file :listtrader.asp
*/
/* shows  branchwise traderwise list of margin */
CREATE PROCEDURE  rpt_conamarbrtrader

@settno varchar(7),
@settype varchar(3),
@branchcd varchar(3)
AS


select distinct  c1.trader,a.party_code
from albmpartypos a, client1 c1, client2 c2 , branches b  
where sett_no =@settno
and sett_type=@settype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd=@branchcd
group by  c1.trader,a.party_code
union 
select distinct c1.trader, a.party_code
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no =@settno
and sett_type=@settype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd=@branchcd
group by  c1.trader,a.party_code
order by c1.trader, a.party_code

/*
select distinct sett_type, sett_no,c1.trader, a.sell_buy , a.scrip_cd, puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpartypos a, client1 c1, client2 c2 , branches b  
where sett_no =@settno
and sett_type=@settype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd=@branchcd
group by sett_type, sett_no, c1.trader, a.scrip_cd, a.sell_buy
union 
select distinct sett_type, sett_no, c1.trader , a.sell_buy , a.scrip_cd,  puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no =@settno
and sett_type=@settype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd=@branchcd
group by sett_type, sett_no, c1.trader, a.scrip_cd, a.sell_buy
order by sett_type, sett_no, c1.trader, a.scrip_cd, a.sell_buy

*/

GO
