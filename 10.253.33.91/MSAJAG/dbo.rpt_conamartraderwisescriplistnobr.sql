-- Object: PROCEDURE dbo.rpt_conamartraderwisescriplistnobr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamartraderwisescriplistnobr    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	ALBM Margin
FILE		-	//asp/cgi-bin/backoffice/consolidated/conALBMMargin/ListClientScrip.asp
CREATED BY	-	Shyam
CREATE DATE	-	04 APR 2001
DESCRIPTION	-	Retrives List Of All Scrips For A Particular Trader, Irrespective Of Branch
*/
CREATE PROCEDURE rpt_conamartraderwisescriplistnobr
@settno varchar(7),
@setttype varchar (3),
@tradercd varchar (15)
AS
select  a.scrip_cd , a.party_code
from albmpartypos a, client1 c1, client2 c2, branches b
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
/*and b.branch_cd= @branchcd*/
and c1.trader= @tradercd
group by a.scrip_cd , a.party_code
union 
select  a.scrip_cd , a.party_code
from albmpos a, client1 c1, client2 c2 , branches b  
where sett_no = @settno
and sett_type= @setttype
and c1.cl_code=c2.cl_code
and a.party_code=c2.party_code
and c1.trader=b.short_name
/*and b.branch_cd= @branchcd*/
and c1.trader= @tradercd
group by a.scrip_cd , a.party_code
order by a.scrip_cd , a.party_code

GO
