-- Object: PROCEDURE dbo.BankDetPrintSpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 7/8/01 3:22:47 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 20-Mar-01 11:43:32 PM ******/

/* Procedure modified by manisha 
Changes : removed refno 
*/

CREATE PROCEDURE BankDetPrintSpP
(@cltcode varchar(10),
@startdate varchar(12),
@enddate varchar(12))
 AS
select convert(varchar,l.vdt ,103),l.acname,l.vno1,l.vno,l.refno, 
party_name = (select l1.acname from ledger l1 where  l.vtyp = l1.vtyp and  l.vno = l1.vno and 
l1.cltcode <> @cltcode  /* and substring(l1.refno,1,11) = substring(l.refno,1,11)*/ 
and l1.vtyp = l.vtyp and l1.vno=l.vno and l1.lno =l.lno and l1.drcr=l.drcr), 
Debit = (Case When l.DRCR = 'D' Then  Vamt  Else  0     End), 
Credit = (Case When l.DRCR='C' Then  Vamt   Else  0   End),  
Narration = (select l3.narr from ledger3 l3 where /*left(l.refno,7)=left(l3.refno,7)*/ l.vtyp =l3.vtyp and l.vno =l3.vno and cltcode =@cltcode)  
from ledger l where  l.cltcode =@cltcode  and convert(varchar,l.vdt ,101) >=@startdate
and convert(varchar,l.vdt,101) <=@enddate

GO
