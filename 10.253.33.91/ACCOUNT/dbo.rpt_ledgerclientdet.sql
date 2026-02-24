-- Object: PROCEDURE dbo.rpt_ledgerclientdet
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 20-Mar-01 11:43:35 PM ******/

/*Changed by sheetal on 24 jan 2001*/
/*Removed refno and used voucher type , no line no, drcr*/
/* report : confirmation report 
   file : tconfirmationreport.asp
*/
/* finds ledger detalied ledger of a partycode till date */
CREATE PROCEDURE rpt_ledgerclientdet
@cltcode varchar(10)
AS

select convert(varchar,VDT,103), vtyp,vno,lno,drcr,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc, 
nar=isnull((select l3.narr from ledger3 l3 where l3.vtyp = ledger.vtyp and l3.vno = ledger.vno ),'') 
from ledger ,vmast
WHERE VDT <= getdate()+ '11:59PM'and CLTCODE=@cltcode and ledger.vtyp=vmast.vtype 
order by vdt, drcr,vtyp 

/*select convert(varchar,VDT,103), refno, vtyp,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc, 
nar=isnull((select l3.narr from ledger3 l3 
where l3.refno=left(ledger.refno,7)),'') from ledger ,vmast
WHERE VDT <= getdate()+ '11:59PM'and CLTCODE=@cltcode and ledger.vtyp=vmast.vtype 
order by vdt, drcr,vtyp */

GO
