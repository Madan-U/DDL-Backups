-- Object: PROCEDURE dbo.rpt_setnsepos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_setnsepos    Script Date: 04/27/2001 4:32:49 PM ******/





/****** Object:  Stored Procedure dbo.rpt_nsepos    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsepos    Script Date: 12/27/00 8:59:14 PM ******/

CREATE PROCEDURE rpt_setnsepos
@code varchar(10),
@name varchar(21),
@trader varchar(15),
@scripcd varchar(10)
AS
select R.party_code,C1.short_name,Pamt=sum(pamt),Pqty=sum(pqty),Samt=sum(samt),Sqty=sum(sqty),
Nqty=sum(pqty)-sum(sqty),Namt=sum(pamt)-sum(samt),scrip_cd,series ,R.sett_no,R.sett_type
from settrptgrpexp  r, Client1 c1, Client2 c2
where r.party_code = c2.party_code and c1.cl_code = c2.cl_code
and r.party_code like ltrim(@code)+'%'
and c1.short_name like ltrim(@name)+'%'
and c1.trader like ltrim(@trader)+'%'
and r.scrip_cd like ltrim(@scripcd)+'%'
group by C1.short_name,R.party_code,scrip_cd,series,R.sett_no,R.sett_type
ORDER BY r.party_code, r.scrip_cd

GO
