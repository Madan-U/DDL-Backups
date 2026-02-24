-- Object: PROCEDURE dbo.bracname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bracname    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.bracname    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.bracname    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.bracname    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.bracname    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.bracname    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.bracname    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.bracname    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE bracname
@acname varchar(35)
AS
select convert(varchar,l.vdt,103), c2.party_code, 
vdesc,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), l.vamt, 
/*l.refno*/l.vtyp,l.vno,l.lno,l.drcr, balamt,vtyp, 
nar=isnull((select l3.narr from ledger3 l3 where /*l3.refno=left(l.refno,7)*/ l3.vno =l.vno and l3.vtyp =l.vtyp), '')
from ledger l, vmast, MSAJAG.DBO.client2 c2, MSAJAG.DBO.client1 c1
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode and vtyp=vtype 
and l.acname = @acname
order by l.vdt

GO
