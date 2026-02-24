-- Object: PROCEDURE dbo.rpt_conamarsbscripwiseclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamarsbscripwiseclientlist    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	ALBM Margin
FILE		-	//asp/cgi-bin/backoffice/consolidated/conALBMMargin/ListScripWiseClient.asp
CREATED BY	-	Shyam
CREATE DATE	-	04 APR 2001
DESCRIPTION	-	Lists All Clients Under A Scrip Under A  Sub-Broker
*/
CREATE PROCEDURE rpt_conamarsbscripwiseclientlist

@settno varchar (7),
@setttype varchar (3),
@subbrokercd varchar (10),
@scripcd varchar(10)

AS

select  a.party_code
from albmpartypos a, client1 c1, client2 c2, subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
and c1.sub_broker= @subbrokercd
/*and c1.trader=b.short_name
and c1.trader= @tradercd*/
and a.scrip_cd = @scripcd
group by a.party_code
union 
select  a.party_code
from albmpos a, client1 c1, client2 c2, subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
and c1.sub_broker= @subbrokercd
/*and c1.trader=b.short_name
and c1.trader= @tradercd*/
and a.scrip_cd = @scripcd
group by a.party_code
order by a.party_code

/*
select  sett_type, sett_no,c2.party_code, c1.short_name, a.sell_buy , a.scrip_cd, puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpartypos a, client1 c1, client2 c2, subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
and c1.sub_broker= @subbrokercd
and c1.trader=b.short_name
and c1.trader= @tradercd
and a.scrip_cd = @scripcd
group by sett_type, sett_no, c2.party_code, c1.short_name, a.scrip_cd, a.sell_buy
union 
select  sett_type, sett_no,  c2.party_code, c1.short_name, a.sell_buy , a.scrip_cd,  puramt=sum(a.pqty), sellamt=sum(a.sqty)
from albmpos a, client1 c1, client2 c2, subbrokers sb
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.sub_broker=sb.sub_broker
and c1.sub_broker= @subbrokercd
and c1.trader=b.short_name
and c1.trader= @tradercd
and a.scrip_cd = @scripcd
group by sett_type, sett_no,  c2.party_code, c1.short_name, a.scrip_cd, a.sell_buy
order by sett_type, sett_no,  c2.party_code, c1.short_name, a.scrip_cd, a.sell_buy
*/

GO
