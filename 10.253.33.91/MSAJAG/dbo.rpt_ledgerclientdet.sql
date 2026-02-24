-- Object: PROCEDURE dbo.rpt_ledgerclientdet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 01/04/1980 5:06:27 AM ******/






/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 09/07/2001 11:09:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 3/23/01 7:59:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 08/18/2001 8:24:20 PM ******/


/****** Object:  Stored Procedure dbo.rpt_ledgerclientdet    Script Date: 7/8/01 3:28:44 PM ******/

/* Modified by VNS on 16-08-2001
    Query for narration modified to get a single line of narattion, even if single/multiple narration line are there per voucher
*/

/* changed by mousami on 26/03/2001 added edt column to query and also a fuction which checks difference between edt and today's date*/
/*Modified by amolika on 1st march'2001 : removed msajag.dbo. & added account.dbo. to all account tables*/
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
nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=account.dbo.ledger.vtyp  and l3.vno = account.dbo.ledger.vno and l3.naratno = account.dbo.ledger.lno) is not null
		then (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=account.dbo.ledger.vtyp  and l3.vno = account.dbo.ledger.vno and l3.naratno = account.dbo.ledger.lno)
		else (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=account.dbo.ledger.vtyp  and l3.vno = account.dbo.ledger.vno)
	end),''),
/*
nar=isnull((select l3.narr from account.dbo.ledger3 l3 where l3.vtyp = account.dbo.ledger.vtyp and l3.vno = account.dbo.ledger.vno ),'') ,
*/
edt, edtdiff=datediff(d, edt , getdate() )
from account.dbo.ledger , account.dbo.vmast
WHERE VDT <= getdate()+ '11:59PM'and CLTCODE=@cltcode and account.dbo.ledger.vtyp = account.dbo.vmast.vtype 
order by vdt, drcr,vtyp

GO
