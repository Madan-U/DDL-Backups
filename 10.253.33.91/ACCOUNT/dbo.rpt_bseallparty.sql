-- Object: PROCEDURE dbo.rpt_bseallparty
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseallparty    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger 
   file :allparty.asp
*/
/*displays detail ledger  for  all parties for a particular cl code */
CREATE PROCEDURE rpt_bseallparty
@acname varchar(35),
@fromdt varchar(10),
@todt varchar(10)
AS
select convert(varchar,l.vdt,103), c2.party_code, vdesc,
dramt=isnull((case drcr when 'd' then vamt end),0),
cramt=isnull((case drcr when 'c' then vamt end),0), l.vamt, l.refno, balamt,vtyp, 
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l.refno,7)), '') 
from ledger l, vmast, bsedb.dbo.client2 c2, bsedb.dbo.client1 c1
 where l.acname = c1.short_Name and c1.cl_code = c2.cl_code
 and c2.party_code=l.cltcode and vtyp=vtype and l.acname =@acname
and vdt>=@fromdt and vdt<=@todt+ ' 11:59pm' /* put space before 11:59*/ 
order by l.vdt

GO
