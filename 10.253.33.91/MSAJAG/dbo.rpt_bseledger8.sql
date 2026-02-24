-- Object: PROCEDURE dbo.rpt_bseledger8
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bseledger8    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger8    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger8    Script Date: 20-Mar-01 11:38:54 PM ******/


/*Modified by amolika on 2nd march'2001 : removed bsedb.dbo. & added account.dbo. to all accounts report*/
/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the drtot, crtot for a particular client

Modified : neelambari 16 Feb 2001
Mod : it gave an erroe if string   '" & "11:59PM" & "'  was joined to getdate
so added '23: 59' which is not in string format

*/
CREATE PROCEDURE rpt_bseledger8
@partycode varchar(10)
AS
/*
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0),
crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger WHERE VDT <= getdate() + '" & "11:59PM" & "' and CLTCODE=@partycode
group by drcr
*/
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0),
crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from account.dbo.ledger
WHERE VDT <= getdate() +'23:59' and CLTCODE=@partycode
group by drcr

GO
