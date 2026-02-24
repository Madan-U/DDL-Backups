-- Object: PROCEDURE dbo.rpt_conamarscripwiseclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamarscripwiseclientlist    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	ALBM Margin
FILE		-	
CREATED BY	-	Shyam
CREATE DATE	-	03 Apr 2001
DESCRIPTION	-	Retrives All Clients For A Particular Scrip
*/
CREATE PROCEDURE rpt_conamarscripwiseclientlist

@settno varchar (7),
@setttype varchar (3),
@branchcd varchar (3),
@tradercd varchar (15),
@scripcd varchar (12)


AS
select  a.party_code
from albmpartypos a, client1 c1, client2 c2 , branches b 
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader= @tradercd
and a.scrip_cd = @scripcd
union 
select  a.party_code
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader= @tradercd
and a.scrip_cd = @scripcd
order by a.party_code

/*
select  sett_type, sett_no,c2.party_code, c1.short_name, a.sell_buy , a.scrip_cd, puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpartypos a, client1 c1, client2 c2 , branches b 
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader= @tradercd
and a.scrip_cd = @scripcd
group by sett_type, sett_no, c2.party_code, c1.short_name, a.scrip_cd, a.sell_buy
union 
select  sett_type, sett_no,  c2.party_code, c1.short_name, a.sell_buy , a.scrip_cd,  puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader= @tradercd
and a.scrip_cd = @scripcd
group by sett_type, sett_no,  c2.party_code, c1.short_name, a.scrip_cd, a.sell_buy
order by sett_type, sett_no,  c2.party_code, c1.short_name, a.scrip_cd, a.sell_buy
*/

GO
