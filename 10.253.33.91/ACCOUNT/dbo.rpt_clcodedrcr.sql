-- Object: PROCEDURE dbo.rpt_clcodedrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : traderledger
   file : cumbal1.asp
*/
/* calculates debit and credit  balances of all accounts of a client */
CREATE PROCEDURE rpt_clcodedrcr
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
from ledger, MSAJAG.DBO.client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM MSAJAG.DBO.CLIENT2 WHERE CL_CODE=@clcode)
and cltcode=party_code 
group by drcr

GO
