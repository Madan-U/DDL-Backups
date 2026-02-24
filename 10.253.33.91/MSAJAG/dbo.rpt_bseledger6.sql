-- Object: PROCEDURE dbo.rpt_bseledger6
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 20-Mar-01 11:38:54 PM ******/


/*Modified by amolika on 2nd march'2001 : removed bsedb.dbo. & added account.dbo. to all accounts report*/
/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the dramt, cramt for a particular client

Modified : neelambari 16 Feb 2001
Mod : it gave an erroe if string   '" & "11:59PM" & "'  was joined to getdate
so added '23: 59' which is not in string format

*/
CREATE PROCEDURE rpt_bseledger6
@code varchar(10)
AS
/*
select convert(varchar,VDT,103), refno, vtyp,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc, 
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(ledger.refno,7)),'')
from ledger , vmast WHERE VDT <= getdate()+ '" & "11:59PM" & "' and 
CLTCODE=@code and ledger.vtyp=vmast.vtype order by vdt, drcr,vtyp 
*/
select convert(varchar,VDT,103), refno, vtyp,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc, 
nar=isnull((select l3.narr from account.dbo.ledger3 l3 where l3.refno=left(account.dbo.ledger.refno,7)),'')
from account.dbo.ledger , account.dbo.vmast 
WHERE VDT <= getdate()+'23:59' and 
CLTCODE=@code and account.dbo.ledger.vtyp = account.dbo.vmast.vtype 
order by vdt, drcr,vtyp

GO
