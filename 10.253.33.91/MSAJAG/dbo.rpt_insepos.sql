-- Object: PROCEDURE dbo.rpt_insepos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_insepos    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insepos    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insepos    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insepos    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insepos    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
CREATE PROCEDURE rpt_insepos
@code varchar(10),
@name varchar(21),
@trader varchar(15),
@scripcd varchar(10),
@pcode varchar(15)
AS
select R.party_code,C1.short_name,Pamt=sum(pamt),Pqty=sum(pqty),Samt=sum(samt),Sqty=sum(sqty),
Nqty=sum(pqty)-sum(sqty),Namt=sum(pamt)-sum(samt),scrip_cd,series ,R.sett_no,R.sett_type
from iRptGrpExp r, Client1 c1, Client2 c2
where r.party_code = c2.party_code and c1.cl_code = c2.cl_code
and r.party_code like ltrim(@code)+'%'
and c1.short_name like ltrim(@name)+'%'
and c1.trader like ltrim(@trader)+'%'
and r.scrip_cd like ltrim(@scripcd)+'%'
and r.partipantcode like  ltrim(@pcode)+'%'
group by C1.short_name,R.party_code,scrip_cd,series,R.sett_no,R.sett_type

GO
