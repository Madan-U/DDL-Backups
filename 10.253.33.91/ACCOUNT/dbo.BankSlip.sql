-- Object: PROCEDURE dbo.BankSlip
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankSlip    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.BankSlip    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.BankSlip    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.BankSlip    Script Date: 09/21/2001 2:39:20 AM ******/

/****** Object:  Stored Procedure dbo.BankSlip    Script Date: 09/20/2001 6:05:56 AM ******/
/*
control name  : BankSlipPrintCtl
Use : To get all slip details to be printed
Written by : Kalpana
Date : 15/02/2001
*/
CREATE PROCEDURE  BankSlip
@SlipNo integer
AS
/*
select  ddno,slipno,sdate,acname,bnkname,brnname,vamt,ddno,l.vtyp,l.vno,l.lno,l.drcr   
from ledger l , slipreceipt s , ledger1 l1 
where s.vno = l.vno and s.vtyp = l.vtyp  and s.slipno =  @SlipNo  and s.vno = l1.vno and s.vtyp = l1.vtyp  and  l.drcr='c' and len(ddno)>1   
and ddno <> 'cash' and l1.drcr=l.drcr order by slipno, sdate
*/

select  ddno,slipno,sdate,acname,bnkname,brnname,vamt,ddno,l.vtyp,l.vno,l.lno,l.drcr   
from ledger l , slipreceipt s , ledger1 l1 
where s.slipno =  @slipno  and s.vno = l1.vno and s.vtyp = l1.vtyp  and s.lno = l1.lno 
and s.vtyp = l.vtyp and s.vno = l.vno and s.lno = l.lno and s.vtyp = '2'
order by slipno, sdate

GO
