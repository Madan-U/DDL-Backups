-- Object: PROCEDURE dbo.BankDetPrintSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BankDetPrintSpP    Script Date: 12/27/00 8:58:43 PM ******/

CREATE PROCEDURE BankDetPrintSpP
(@cltcode varchar(10),
@startdate varchar(12),
@enddate varchar(12))
 AS
select convert(varchar,l.vdt ,103),l.acname,l.vno1,l.vno,l.refno, 
 party_name = (select l1.acname from ledger l1 where  l.vtyp = l1.vtyp and  l.vno = l1.vno and 
l1.cltcode <> @cltcode and substring(l1.refno,1,11) = substring(l.refno,1,11)), 
 Debit = (Case When l.DRCR = 'D' Then  Vamt  Else  0     End), 
Credit = (Case When l.DRCR='C' Then  Vamt   Else  0   End),  
Narration = (select l3.narr from ledger3 l3 where left(l.refno,7)=left(l3.refno,7) and cltcode =@cltcode)  
from ledger l where  l.cltcode =@cltcode  and convert(varchar,l.vdt ,101) >=@startdate
and convert(varchar,l.vdt,101) <=@enddate

GO
