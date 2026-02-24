-- Object: PROCEDURE dbo.rpt_singleclientdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_singleclientdrcr    Script Date: 20-Mar-01 11:43:35 PM ******/

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
from ledger WHERE VDT <= getdate() + '11:59PM' and 
CLTCODE=@cltcode 
group by drcr

GO
