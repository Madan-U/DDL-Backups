-- Object: PROCEDURE dbo.acc_BankSlipReprint
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/*Cahnged by amit to display the acname and accode */       
/****** Object:  Stored Procedure dbo.acc_BankSlipReprint    Script Date: 04/07/2003 12:28:25 PM ******/      
/****** Object:  Stored Procedure dbo.BankSlipReprint    Script Date: 10/16/2002 4:40:54 PM ******/      
CREATE proc acc_BankSlipReprint      
@cltcode  varchar(10),      
@booktype varchar(2),      
@startslip int,      
@endslip int
As      
      
/*      
select  SlipNo, ddno, slipdate, acname, bnkname, brnname, relamt, cltcode, l1.vno, l1.lno      
from ledger l , ledger1 l1       
where l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype = l1.booktype  and l.vtyp in ( '2', '19')      
and l.booktype = @booktype and slipno >= @startslip and slipno <= @endslip and l.cltcode = @cltcode      
order By SlipNo, Slipdate, l1.vno, l1.lno      
*/      
      
select  SlipNo, ddno, slipdate, acname, bnkname, brnname, relamt, cltcode, l1.vno, l1.lno      
from ledger l , ledger1 l1       
where l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype = l1.booktype  and l.vtyp in ( '2', '19')      
and l.booktype = @booktype and slipno >= @startslip and slipno <= @endslip and l.cltcode <> @cltcode      
and l.vno in  (select vno from ledger l2 where  cltcode =@cltcode and l.vtyp=l2.vtyp and l.booktype = l2.booktype )      
order By SlipNo, Slipdate, l1.vno, l1.lno

GO
