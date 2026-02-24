-- Object: PROCEDURE dbo.rpt_conamartraderwiseclientlistnobr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamartraderwiseclientlistnobr    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	ALBM MArgin Report
FILE		-	//asp/cgi-bin/backoffice/consolidated/conALBMMargin/ListClientScrip.asp
CREATED ON	-	04 APR 2001
CREATED BY	-	Shyam
DESCRIPTION	-	Retrive Trader Wise Client List, Irrespective Of Branch
*/
CREATE PROCEDURE rpt_conamartraderwiseclientlistnobr
@settno varchar (7),
@setttype varchar (3),
@tradercd varchar (15)
AS
select  c1.trader, a.party_code
from albmpartypos a, client1 c1, client2 c2, branches b
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and c1.trader= @tradercd
group by  c1.trader, a.party_code
union 
select  c1.trader, a.party_code
from albmpos a, client1 c1, client2 c2, branches b
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
and c1.trader= @tradercd
group by  c1.trader, a.party_code
order by  c1.trader, a.party_code

GO
