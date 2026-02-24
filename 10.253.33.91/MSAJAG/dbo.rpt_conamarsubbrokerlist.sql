-- Object: PROCEDURE dbo.rpt_conamarsubbrokerlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamarsubbrokerlist    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	AMBM Margin
FILE		-	//asp/cgi-bin/backoffice/consolidated/conALBMMargin/ListBranch.asp
CREATED BY	-	Shyam
CREATE DATE	-	04 APR 2001
DESCRIPTION	-	Lists All The Sub-Brokers & Their Margin Dtls. For A Particular Sett'mt

*/
CREATE PROCEDURE rpt_conamarsubbrokerlist
@settno varchar (7),
@setttype varchar(3)
AS
select distinct sb.sub_broker, a.party_code
from albmpartypos a, client1 c1, client2 c2 ,subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
group by  sb.sub_broker,a.party_code
union 
select distinct sb.sub_broker,a.party_code
from albmpos a, client1 c1, client2 c2 ,subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
group by sb.sub_broker, a.party_code
order by  sb.sub_broker, a.party_code

/*
select distinct sett_type, sett_no,sb.sub_broker , a.sell_buy , a.scrip_cd, puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpartypos a, client1 c1, client2 c2 ,subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
group by sett_type, sett_no, sb.sub_broker, a.scrip_cd, a.sell_buy
union 
select distinct sett_type, sett_no, sb.sub_broker, a.sell_buy , a.scrip_cd,  puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpos a, client1 c1, client2 c2 ,subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
group by sett_type, sett_no, sb.sub_broker, a.scrip_cd, a.sell_buy
order by sett_type, sett_no, sb.sub_broker, a.scrip_cd, a.sell_buy
*/

GO
