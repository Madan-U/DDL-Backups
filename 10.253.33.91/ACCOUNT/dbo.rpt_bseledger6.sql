-- Object: PROCEDURE dbo.rpt_bseledger6
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseledger6    Script Date: 20-Mar-01 11:43:35 PM ******/

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
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(ledger.refno,7)),'')
from ledger , vmast WHERE VDT <= getdate()+'23:59' and 
CLTCODE=@code and ledger.vtyp=vmast.vtype order by vdt, drcr,vtyp

GO
