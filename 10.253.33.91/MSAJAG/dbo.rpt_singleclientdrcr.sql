-- Object: PROCEDURE dbo.rpt_singleclientdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_singleclientdrcr    Script Date: 7/8/01 3:28:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_singleclientdrcr    Script Date: 2/17/01 5:19:54 PM ******/


/****** Object:  Stored Procedure dbo.rpt_singleclientdrcr    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_singleclientdrcr    Script Date: 20-Mar-01 11:39:03 PM ******/


/*Modified by amolika on 1st march'2001 ; removed NEWMSAJAG.DBO. & added account.dbo. to all account report*/
/* report : confirmation report
   file : tconfirmation.asp
   report : traderledger
   file :  singleparty.asp
*/
/* calculates debit and credit of a partycode from ledger till today*/
CREATE PROCEDURE rpt_singleclientdrcr
@cltcode varchar(10)
AS
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from account.dbo.ledger WHERE VDT <= getdate() + '11:59PM' and 
CLTCODE=@cltcode 
group by drcr

GO
