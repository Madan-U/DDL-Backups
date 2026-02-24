-- Object: PROCEDURE dbo.rpt_conamartraderwisescriplist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamartraderwisescriplist    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	ALBM Margin
FILE		-	
CREATED BY	-	Shyam
CREATED ON	-	APR 03 2001
DESCRIPTION	-	Retrives List Of All Scrips For A Particular Trader
*/

CREATE PROCEDURE rpt_conamartraderwisescriplist

@settno varchar(7),
@setttype varchar (3),
@branchcd varchar (3),
@trader varchar (15)

AS
select  a.scrip_cd, a.party_code
from albmpartypos a, client1 c1, client2 c2 , branches b 
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader=@trader
group by a.scrip_cd, a.party_code
union 
select a.scrip_cd, a.party_code  
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader= @trader
group by a.scrip_cd, a.party_code
order by a.scrip_cd, a.party_code

/*
select  sett_type, sett_no,a.scrip_cd, a.sell_buy , puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpartypos a, client1 c1, client2 c2 , branches b 
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader=@trader
group by sett_type, sett_no, a.scrip_cd, a.sell_buy
union 
select  sett_type, sett_no, a.scrip_cd ,a.sell_buy , puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and b.branch_cd= @branchcd
and c1.trader= @trader
group by sett_type, sett_no, a.scrip_cd, a.sell_buy
order by sett_type, sett_no, a.scrip_cd, a.sell_buy
*/

GO
